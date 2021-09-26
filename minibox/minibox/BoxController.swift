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
		var studiedLevels = Set<Int>()
		
		let dayDone = box.dayDone
		let allDue = Set(box.allDue)
		studiedLevels = Set(box.latestLevels)

		guard !dayDone else {
			print("\n☁️ The day is already done. No level shall be added."); return box
		}
		
		studiedLevels.insert(level)
		

		let equal = studiedLevels == allDue
		
		switch equal {
		case true:
			let cal = Calendar(identifier: .gregorian)
			let today = cal.startOfDay(for: Date())
			
			box.latestLevels = []
			box.latestStudyDate = today
			box.dayDone = true
		case false:
			box.latestLevels = Array(studiedLevels)
		}
		
		return box

	}


	/// - Returns: `Set<Int>` of levels DUE right now. EXCLUDING levels studied.
	/// - Parameters:
	/// 	- completion: ```(dayDone)```
	/// 	- dayDone: `Bool`   Whether the day is done studying.
	/// 	-  allDues: `Set<Int>` ALL levels due that day.
	///		- day: The day which we want to get levels due
	/// Get due levels including MISSED days
	func getLevels(fromBox box: Box, _ completion: @escaping(_ dayDone: Bool, _ allDues:Set<Int>) -> Void ) -> Set<Int> {
		
		/// whether a level is done at the moment, with studied levels excluded
		var dueNow: Set<Int> = Set<Int>()
		
		/// All levels due that day
		var allDue: Set<Int> =  Set(box.allDue)

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
		
		var studied = Set(box.latestLevels)
		dayDone = box.dayDone
		
		guard !Calendar.current.isDateInToday(latestStudyDate) else {
			// was studied today 🍺
			switch dayDone {
			case true:
				completion(true, allDue); return dueNow
			case false:
				if !didSetupToday { // needs setup
					let exclusiveDue = getLevels(fromDayDiff: 0)
					dueNow = checkStudied(origin: exclusiveDue, studied: studied)
					updateProperty(toBox: box, setupDate: today, allDue: dueNow)
					completion(dayDone, allDue); return dueNow
				} else {
					dueNow = checkStudied(origin: allDue, studied: studied)
					completion(dayDone, allDue); return dueNow
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
					let todayExclusive = getExclusiveDues(startDate: startDate, day: today)
					studied = studied.subtracting(todayExclusive)
				}
				
				allDue = getLevels(forBox: box, sinceDate: latestStudyDate)
				updateProperty(toBox: box, setupDate: today, allDue: allDue)
			}
			
			dueNow = checkStudied(origin: allDue, studied: studied)
			completion(dayDone, allDue); return dueNow
		}
		
		// 🔥
		print("🔥")
		if dayDiff > 1 { // 🍡
			print("🍡")
			dayDone = false
			allDue = getLevels(forBox: box, sinceDate: latestStudyDate)
			updateProperty(toBox: box, setupDate: today, allDue: allDue, dayDone: false)

		} else {
			// 🍉
			print("🍉")
			allDue = getExclusiveDues(startDate: startDate, day: today)
			
			dayDone = false
			
			updateProperty(toBox: box, setupDate: today, allDue: allDue, dayDone: false)
		}
		
		dueNow = checkStudied(origin: allDue, studied: studied)
		completion(dayDone, allDue); return dueNow

	}

	@discardableResult
	func updateProperty(toBox box: Box, setupDate: Date, allDue: Set<Int>? = nil, dayDone: Bool? = nil) -> Box {
		let box = box
		
		box.setupDate = setupDate
		
		if let dayDone = dayDone {
			box.dayDone = dayDone
		}
		
		if let allDue = allDue {
			box.allDue = Array(allDue)
		}

		return box
	}
		
	/// Get level that is due for today, unrelated to missed days
	func getExclusiveDues(startDate: Date, day: Date) -> Set<Int> {
		guard let dayDiff = Calendar.current.dateComponents([.day], from: startDate, to: day).day else { fatalError("\n🌸 Day is unexpectedly nil")
		}
		
		return getLevels(fromDayDiff: dayDiff)
	}

	/// remove studied levels
	func checkStudied(origin: Set<Int>, studied: Set<Int>) -> Set<Int> {
		var levels = origin
		for level in studied {
			levels.remove(level)
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
	func getLevels(forBox box: Box, sinceDate date: Date) -> Set<Int> {
		var levels = Set<Int>()
		let startDate = box.startDate
		
		let cal = Calendar(identifier: .gregorian)
		let today = cal.startOfDay(for: Date())
			
		let dayDiff = DateHelper.getDayDiff(from: date, to: today)
		guard dayDiff >= 1 else {
			fatalError("Wrong method called 😵");
		}
		
		// didn't study for too long!
		guard dayDiff <= 64 else {
			return Set(Level.allCases.map { $0.rawValue })
		}
		
		for i in 1...dayDiff {
			if let d = Calendar.current.date(byAdding: .day, value: i, to: date){
				levels = getLevels(at: d, startDate: startDate, prevLevels: levels)
			}
		}
		
		return levels
	}

	/// Get level at a date, replacing values for the dictionary passed in.
	func getLevels(at day: Date, startDate: Date, prevLevels: Set<Int> = Set<Int>()) -> Set<Int> {
		
		var levels: Set<Int> = prevLevels
		
		let dayDiff = DateHelper.getDayDiff(from: startDate, to: day)
			
		levels = getLevels(fromDayDiff: dayDiff, withPreviousLevels: levels)
		
		return levels
	}

	/// fundamental function to calculate due levels and update the dictionary passed in
	func getLevels(fromDayDiff dayDiff: Int, withPreviousLevels prevLevels: Set<Int> = Set<Int>()) -> Set<Int> {
		var levels = prevLevels
		let intervalDay = dayDiff % 64 + 1
		let mod16 = intervalDay % 16
		let cycleDay = dayDiff + 1

		// check 7
		if  intervalDay == 56 {
			if cycleDay > 56  { // No level-7 box should be studied on the 56th day
				levels.insert(Level.seven.rawValue)
			}
		}

		// check 6
		if intervalDay == 24 || intervalDay == 59  {
			if cycleDay > 24  { // No level-6 box should be studied on the 24rd day
				levels.insert(Level.six.rawValue)
			}
		}

		if mod16 == 12 {
			if cycleDay > 12  { // No level-5 box should be studied on the 12nd day {
				levels.insert(Level.five.rawValue)
			}
		}

		if mod16 == 4 || mod16 == 13 {
			if cycleDay > 4  { // No level-4 box should be studied on the forth day
				levels.insert(Level.four.rawValue)
			}
		}

		if mod16 == 2 || mod16 == 6 || mod16 == 10 || mod16 == 14 {
			if cycleDay > 2  { // No level-3 box should be studied on the second day
				levels.insert(Level.three.rawValue)
			}
		}

		if (intervalDay + 1) % 2 == 0 {
			if cycleDay > 1 { // No level-2 box should be studied on the first day
				levels.insert(Level.two.rawValue)
			}
		}

		levels.insert(Level.one.rawValue)
		return levels
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

