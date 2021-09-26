//
//  BoxController.swift
//  minibox
//
//  Created by Anne on 27/9/20.
//

import Foundation

enum Level: Int, CaseIterable {
	case one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7
}


// MARK: - Imitation of Methods (exclude updating to the cloud)

public final class BoxController {
		
	/// append levels to the existing levels and update latest study date
	func update(box: Box, withLatestLevel level: Int) -> Box {
		/// levels studied
		var studiedArr: [Int] = []
		
		let dayDone = box.dayDone
		let allDue = box.allDue
		studiedArr = box.latestLevels
		
		guard studiedArr.firstIndex(of: level) == nil else {
			print("\n🍒 The level you tried to add was already added before."); return box
		}
		
		guard !dayDone else {
			print("\n☁️ The day is already done. No level shall be added."); return box
		}
		
		studiedArr += [level]
		

		let equal = studiedArr.sorted { $0 < $1 }.elementsEqual(allDue.sorted { $0 < $1 }) {
			$0 == $1
		}
		
		switch equal {
		case true:
			let cal = Calendar(identifier: .gregorian)
			let today = cal.startOfDay(for: Date())
			
			box.latestLevels = []
			box.latestStudyDate = today
			box.dayDone = true
		case false:
			box.latestLevels = studiedArr
		}
		
		return box

	}


	/// - Returns: `[Int:Bool]` of level and whether it is DUE right now. EXCLUDING levels studied.
	/// - Parameters:
	/// 	- completion: ```(dayDone, dues)```
	/// 	- dayDone: `Bool`   Whether the day is done studying.
	/// 	-  allDues: `[Int]` ALL levels due that day.
	///		- day: The day which we want to get levels due
	/// Get due levels including MISSED days
	func getLevels(fromBox box: Box, _ completion: @escaping(_ dayDone: Bool, _ allDues:[Int]) -> Void ) -> [Int:Bool] {
		
		/// whether a level is done at the moment, with studied levels excluded
		var dueNowDict: [Int:Bool] = [:]
		
		/// All levels due that day
		var allDue: [Int] =  box.allDue
		var allDueDict = setUpLevelDict(arr: allDue)
		
		/// whether the day is done studying
		var dayDone  = box.dayDone
		
		let cal = Calendar(identifier: .gregorian)
		let today = cal.startOfDay(for: Date())
		
		let startDate = box.startDate
		let latestStudyDate = box.latestStudyDate
		let setupDate = box.setupDate
		
		// difference from latest study date
		let dayDiff = DateHelper.getDayDiff(from: latestStudyDate, to: Date())

		let didSetupToday = Calendar.current.isDateInToday(setupDate)
		
		var studied = box.latestLevels
		dayDone = box.dayDone
		dueNowDict = setUpEmptyLevelsDict()
		
		guard !Calendar.current.isDateInToday(latestStudyDate) else {
			// was studied today 🍺
			switch dayDone {
			case true:
				completion(true, allDue); return dueNowDict
			case false:
				if !didSetupToday { // needs setup
					let exclusiveDue = getLevels(fromDayDiff: 0, toLevelDict: setUpEmptyLevelsDict())
					dueNowDict = checkStudied(origin: exclusiveDue, studied: studied)
					let dueNowArr = setUpLevelArray(levels: dueNowDict)
					updateProperty(toBox: box, setupDate: today, allDue: dueNowArr)
					completion(dayDone, allDue); return dueNowDict
				} else {
					dueNowDict = checkStudied(origin: allDueDict, studied: studied)
					completion(dayDone, allDue); return dueNowDict
				}
			}
		}
		
		// 🌈
		print("🌈")
		guard dayDone else {
			// 💩
			print("💩")
			switch didSetupToday {
			case true: break
			case false:
				// 🍦
				print("🍦")
				if studied.count > 0 { // 🌿
					print("🌿")
					guard let todayExclusive = getExclusiveDues(startDate: startDate, day: today).arr else { print("\n🍰 Can't get exclusive due :(( #1"); completion(dayDone, allDue); return dueNowDict }
					
					for level in studied {
						if todayExclusive.contains(level) {
							if let index = studied.firstIndex(of: level) {
								studied.remove(at: index)
							}
						}
					}
				}
				
				let arr = getLevels(forBox: box, sinceDate: latestStudyDate) ?? []
				allDueDict = setUpLevelDict(arr: arr)
				allDue = arr
				updateProperty(toBox: box, setupDate: today, allDue: allDue)
				
			}
			
			dueNowDict = checkStudied(origin: allDueDict, studied: studied)
			completion(dayDone, allDue); return dueNowDict
		}
		
		// 🔥
		print("🔥")
		if dayDiff > 1 { // 🍡
			print("🍡")
			dayDone = false
			allDue = getLevels(forBox: box, sinceDate: latestStudyDate) ?? allDue
			updateProperty(toBox: box, setupDate: today, allDue: allDue, dayDone: false)

		} else {
			// 🍉
			print("🍉")
			allDue = getExclusiveDues(startDate: startDate, day: today).arr ?? allDue
			
			dayDone = false
			
			updateProperty(toBox: box, setupDate: today, allDue: allDue, dayDone: false)
		}
		
		dueNowDict = checkStudied(origin: allDueDict, studied: studied)
		completion(dayDone, allDue); return dueNowDict

	}

	@discardableResult
	func updateProperty(toBox box: Box, setupDate: Date, allDue: [Int]? = nil, dayDone: Bool? = nil) -> Box {
		let box = box
		
		box.setupDate = setupDate
		
		if let dayDone = dayDone {
			box.dayDone = dayDone
		}
		
		if let allDue = allDue {
			box.allDue = allDue
		}

		return box
	}
		
	/// Get level that is due for today, unrelated to missed days
	func getExclusiveDues(startDate: Date, day: Date) -> (dict: [Int:Bool]?, arr: [Int]?) {
		var levelsDict = setUpEmptyLevelsDict()
		
		guard let dayDiff = Calendar.current.dateComponents([.day], from: startDate, to: day).day else { print("\n🌸 Day is unexpectedly nil") ; return (nil, nil) }
		
		levelsDict = getLevels(fromDayDiff: dayDiff, toLevelDict: levelsDict)
		
		let levelsArr = setUpLevelArray(levels: levelsDict)
		
		return (dict: levelsDict, arr: levelsArr)
	}


	/// turn dictionary pairs into array
	func setUpLevelArray(levels: [Int:Bool]) -> [Int]{
		var levelsArr: [Int] = []
		for num in Level.allCases {
			if levels[num.rawValue] == true {
				levelsArr += [num.rawValue]
			}
		}
		return levelsArr.sorted { $0 > $1 }
	}

	/// turn array into dictionary
	func setUpLevelDict(arr: [Int]) -> [Int: Bool]{
		var levels: [Int: Bool] = [:]
		for i in arr {
			levels[i] = true
		}
		return levels
	}

	func setUpEmptyLevelsDict() -> [Int:Bool] {
		var levels: [Int:Bool] = [:]
		for level in Level.allCases {
			levels[level.rawValue] = false
		}
		return levels
	}

	/// set level to false if studied
	func checkStudied(origin: [Int: Bool], studied: [Int]) -> [Int: Bool] {
		var levels = origin
		for i in studied {
			levels[i] = false
		}
		return levels
	}

	func printLevelsToDebugLog(title: String, levels: [Int:Bool]) {
		var string = "\n\t\t\t\t🌲 \(title): TRUE = "
		for level in Level.allCases {
			if let isTrue = levels[level.rawValue] {
				if isTrue {
					string += " \(level.rawValue)"
				}
			}
		}
		string += "\n"
		print(string)
	}
		
	/// Get all levels since a date in the PAST until today
	/// - Parameters:
	///   - sinceDate: the date in the past to start calculating from
	/// - Returns: all levels due
	func getLevels(forBox box: Box, sinceDate date: Date) -> [Int]? {
		var levels = setUpEmptyLevelsDict()
		let startDate = box.startDate
		
		let cal = Calendar(identifier: .gregorian)
		let today = cal.startOfDay(for: Date())
			
		let dayDiff = DateHelper.getDayDiff(from: date, to: today)
		print("\n🧪 Daydiff: \(dayDiff)")
		
		guard dayDiff > 1 else {
			print("\n☁️ Wrong function"); return nil
		}
		
		// didn't study for too long!
		guard dayDiff <= 64 else {
			for level in Level.allCases {
				levels[level.rawValue] = true
			}
			return setUpLevelArray(levels: levels)
		}
		
		for i in 1...dayDiff {
			if let d = Calendar.current.date(byAdding: .day, value: i, to: date){
				levels = getLevels(at: d, startDate: startDate, prevLevels: levels)
			}
		}
		
		return setUpLevelArray(levels: levels)
	}

	/// Get level at a date, replacing values for the dictionary passed in.
	func getLevels(at day: Date, startDate: Date, prevLevels: [Int:Bool]) -> [Int:Bool] {
		
		var levels: [Int:Bool] = prevLevels
		
		let dayDiff = DateHelper.getDayDiff(from: startDate, to: day)
			
		levels = getLevels(fromDayDiff: dayDiff, toLevelDict: levels)
		
		return levels
	}

	/// fundamental function to calculate due levels and update the dictionary passed in
	func getLevels(fromDayDiff dayDiff: Int, toLevelDict levelsDict: [Int:Bool]) -> [Int:Bool] {
		var levelsDict = levelsDict
		let intervalDay = dayDiff % 64 + 1
		let mod16 = intervalDay % 16
		let cycleDay = dayDiff + 1

		// check 7
		if  intervalDay == 56 {
			if cycleDay > 56  { // No level-7 box should be studied on the 56th day
				levelsDict[Level.seven.rawValue] = true
			}
		}

		// check 6
		if intervalDay == 24 || intervalDay == 59  {
			if cycleDay > 24  { // No level-6 box should be studied on the 24rd day
				levelsDict[Level.six.rawValue] = true
			}
		}

		if mod16 == 12 {
			if cycleDay > 12  { // No level-5 box should be studied on the 12nd day {
				levelsDict[Level.five.rawValue] = true
			}
		}

		if mod16 == 4 || mod16 == 13 {
			if cycleDay > 4  { // No level-4 box should be studied on the forth day
				levelsDict[Level.four.rawValue] = true
			}
		}

		if mod16 == 2 || mod16 == 6 || mod16 == 10 || mod16 == 14 {
			if cycleDay > 2  { // No level-3 box should be studied on the second day
				levelsDict[Level.three.rawValue] = true
			}
		}

		if (intervalDay + 1) % 2 == 0 {
			if cycleDay > 1 { // No level-2 box should be studied on the first day
				levelsDict[Level.two.rawValue] = true
			}
		}

		levelsDict[Level.one.rawValue] = true
		return levelsDict
	}


	func getDayInCycle(startDate: Date, for day: Date) -> (cycle: Int, day: Int)? {
		var dayNum = 0
		var cycleNum = 0
		guard let diff = Calendar.current.dateComponents([.day], from: startDate, to: day).day else { return nil }
		dayNum = diff % 64 + 1
		cycleNum = diff / 64 + 1
		
		return (cycle: cycleNum, day: dayNum)
	}
}

