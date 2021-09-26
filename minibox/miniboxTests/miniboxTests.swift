//
//  miniboxTests.swift
//  miniboxTests
//
//  Created by Anne on 27/9/20.
//

import XCTest
@testable import minibox

class miniboxTests: XCTestCase {
	let boxCtr = BoxController()
	let emptyDict =  BoxController().setUpEmptyLevelsDict()
	
	// MARK:- Test Logic
	
	func test_interval_day(){
		for day in 1...64 {
			let diff = day - 1
			let intervalDay = diff % 64 + 1
			XCTAssert(intervalDay == day)
		}
	}
	
	func test_firstWeekDue(){
		let due1 = boxCtr.getLevels(fromDayDiff: 0, toLevelDict: emptyDict)
		let due2 = boxCtr.getLevels(fromDayDiff: 1, toLevelDict: emptyDict)
		let due3 = boxCtr.getLevels(fromDayDiff: 2, toLevelDict: emptyDict)
		let due4 = boxCtr.getLevels(fromDayDiff: 3, toLevelDict: emptyDict)
		let due5 = boxCtr.getLevels(fromDayDiff: 4, toLevelDict: emptyDict)
		let due6 = boxCtr.getLevels(fromDayDiff: 5, toLevelDict: emptyDict)
		let due7 = boxCtr.getLevels(fromDayDiff: 6, toLevelDict: emptyDict)
		let due8 = boxCtr.getLevels(fromDayDiff: 7, toLevelDict: emptyDict)

		let arr1 = boxCtr.setUpLevelArray(levels: due1)
		let arr2 = boxCtr.setUpLevelArray(levels: due2)
		let arr3 = boxCtr.setUpLevelArray(levels: due3)
		let arr4 = boxCtr.setUpLevelArray(levels: due4)
		let arr5 = boxCtr.setUpLevelArray(levels: due5)
		let arr6 = boxCtr.setUpLevelArray(levels: due6)
		let arr7 = boxCtr.setUpLevelArray(levels: due7)
		let arr8 = boxCtr.setUpLevelArray(levels: due8)

		XCTAssertEqual(arr1, [1], "🐙 Failed: Day 1 has incorrect levels.")
		XCTAssertEqual(arr2, [1], "🐙 Failed: Day 2 has incorrect levels.")
		XCTAssertEqual(arr3, [2,1], "🐙 Failed: Day 3 has incorrect levels.")
		XCTAssertEqual(arr4, [1], "🐙 Failed: Day 4 has incorrect levels.")
		XCTAssertEqual(arr5, [2, 1], "🐙 Failed: Day 5 has incorrect levels.")
		XCTAssertEqual(arr6, [3, 1], "🐙 Failed: Day 6 has incorrect levels.")
		XCTAssertEqual(arr7, [2, 1], "🐙 Failed: Day 7 has incorrect levels.")
		XCTAssertEqual(arr8, [1], "🐙 Failed: Day 8 has incorrect levels.")

	}
	
	func test_firstCycle_Exceptions(){
		let due1 = boxCtr.getLevels(fromDayDiff: 0, toLevelDict: emptyDict)
		let due2 = boxCtr.getLevels(fromDayDiff: 1, toLevelDict: emptyDict)
		let due4 = boxCtr.getLevels(fromDayDiff: 3, toLevelDict: emptyDict)
		let due12 = boxCtr.getLevels(fromDayDiff: 11, toLevelDict: emptyDict)
		let due24 = boxCtr.getLevels(fromDayDiff: 23, toLevelDict: emptyDict)
		let due56 = boxCtr.getLevels(fromDayDiff: 55, toLevelDict: emptyDict)


		let arr1 = boxCtr.setUpLevelArray(levels: due1)
		let arr2 = boxCtr.setUpLevelArray(levels: due2)
		let arr4 = boxCtr.setUpLevelArray(levels: due4)
		let arr12 = boxCtr.setUpLevelArray(levels: due12)
		let arr24 = boxCtr.setUpLevelArray(levels: due24)
		let arr56 = boxCtr.setUpLevelArray(levels: due56)

		XCTAssertEqual(arr1, [1], "🐙 Failed: Day 1 has incorrect levels.")
		XCTAssertEqual(arr2, [1], "🐙 Failed: Day 2 has incorrect levels.")
		XCTAssertEqual(arr4, [1], "🐙 Failed: Day 4 has incorrect levels.")
		XCTAssertEqual(arr12, [1], "🐙 Failed: Day 12 has incorrect levels.")
		XCTAssertEqual(arr24, [1], "🐙 Failed: Day 24 has incorrect levels.")
		XCTAssertEqual(arr56, [1], "🐙 Failed: Day 56 has incorrect levels.")
	}

	func test_secondCycle_Exceptions(){
		let oneCycle = 64
		let due1 = boxCtr.getLevels(fromDayDiff: oneCycle + 0, toLevelDict: emptyDict)
		let due2 = boxCtr.getLevels(fromDayDiff: oneCycle + 1, toLevelDict: emptyDict)
		let due4 = boxCtr.getLevels(fromDayDiff: oneCycle + 3, toLevelDict: emptyDict)
		let due12 = boxCtr.getLevels(fromDayDiff: oneCycle + 11, toLevelDict: emptyDict)
		let due24 = boxCtr.getLevels(fromDayDiff: oneCycle + 23, toLevelDict: emptyDict)
		let due56 = boxCtr.getLevels(fromDayDiff: oneCycle + 55, toLevelDict: emptyDict)


		let arr1 = boxCtr.setUpLevelArray(levels: due1)
		let arr2 = boxCtr.setUpLevelArray(levels: due2)
		let arr4 = boxCtr.setUpLevelArray(levels: due4)
		let arr12 = boxCtr.setUpLevelArray(levels: due12)
		let arr24 = boxCtr.setUpLevelArray(levels: due24)
		let arr56 = boxCtr.setUpLevelArray(levels: due56)

		XCTAssertEqual(arr1, [2,1], "🐙 Failed: Day 1 has incorrect levels.")
		XCTAssertEqual(arr2, [3,1], "🐙 Failed: Day 2 has incorrect levels.")
		XCTAssertEqual(arr4, [4,1], "🐙 Failed: Day 4 has incorrect levels.")
		XCTAssertEqual(arr12, [5, 1], "🐙 Failed: Day 12 has incorrect levels.")
		XCTAssertEqual(arr24, [6, 1], "🐙 Failed: Day 24 has incorrect levels.")
		XCTAssertEqual(arr56, [7, 1], "🐙 Failed: Day 56 has incorrect levels.")
	}
	
	func test_getLevels_FromDate(){
		guard let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date()) else { XCTFail(); return }
		guard let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: Date()) else { XCTFail(); return }

		let allDueDict = boxCtr.getLevels(at: threeDaysAgo, startDate: fiveDaysAgo, prevLevels: emptyDict)
		let allDue = boxCtr.setUpLevelArray(levels: allDueDict)
		XCTAssertEqual(allDueDict[2], true)
		XCTAssertEqual(allDue, [2,1])

	}
	
	func test_missedLevel(){
		
		// test a few days missed
		guard let startDate1 = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else { XCTFail(); return }
		guard let lastStudied1 = Calendar.current.date(byAdding: .day, value: +3, to: startDate1) else { XCTFail(); return }
		
		let box1 = Box(startDate: startDate1)
		let threeDaysMissed = boxCtr.getLevels(forBox: box1, sinceDate: lastStudied1)
		
		// many days missed ...
		guard let startDate2 = Calendar.current.date(byAdding: .day, value: (-23 - 64), to: Date()) else { XCTFail(); return }
		guard let lastStudied2 = Calendar.current.date(byAdding: .day, value: +3, to: startDate2) else { XCTFail(); return }
		
		let box2 = Box(startDate: startDate2)
		let manyDaysMissed = boxCtr.getLevels(forBox: box2, sinceDate: lastStudied2)
		
		XCTAssertEqual(threeDaysMissed, [3,2,1])
		XCTAssertEqual(manyDaysMissed, [7,6,5,4,3,2,1])

	}
	
	
	// MARK: - Test Box Creation
	// test creating new box
	func test_createNewBox(){
		let cal = Calendar(identifier: .gregorian)
		let today = cal.startOfDay(for: Date())
		let box = Box(startDate: today)
		
		XCTAssert(box.dayDone == false)
		XCTAssert(Calendar.current.isDateInToday(box.setupDate))
		XCTAssert(box.latestLevels.count == 0)
		XCTAssert(box.allDue == [1])
	}
	
	
	// MARK: - Test fetching
	// test fetching level from a box that was studied yesterday
	func test_fetch_from_yesterday(){
		let cal = Calendar(identifier: .gregorian)
		let today = cal.startOfDay(for: Date())
		guard let startDate = Calendar.current.date(byAdding: .day, value: -12, to: today),
			  let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) else { XCTFail(); return }
		

		let levelsDictforYesterday = boxCtr.getLevels(at: yesterday, startDate: startDate, prevLevels: emptyDict)
		let yesterdayLevels = boxCtr.setUpLevelArray(levels: levelsDictforYesterday)
		XCTAssert(yesterdayLevels == [1])
		
		let box = Box(startDate: startDate, latestStudyDate: yesterday, latestLevels: yesterdayLevels, allDue: yesterdayLevels, dayDone: true)
		
		let diffSinceStarted = DateHelper.getDayDiff(from: startDate, to: Date())
		XCTAssertEqual(diffSinceStarted, 12)
		
		let dueTodayExclusively = boxCtr.getExclusiveDues(startDate: startDate, day: today).arr ?? []
		XCTAssertEqual(dueTodayExclusively, [4,2,1])
		
		let diff = DateHelper.getDayDiff(from: box.latestStudyDate, to: Date())
		XCTAssertEqual(diff, 1)
		

		
		let _ = boxCtr.getLevels(fromBox: box) { (dayDone, allDues) in
			// should be updated to what we should study today
			XCTAssertFalse(dayDone)
			XCTAssertFalse(box.dayDone)
			XCTAssertEqual(allDues, [4,2,1])
			let isSetupToday = Calendar.current.isDateInToday(box.setupDate)
			XCTAssert(isSetupToday)
		}
	}
	
	// test fetching level from a box that was studied yesterday but didn't complete all levels

}
