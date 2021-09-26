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
	
	// MARK:- Test Logic
	func test_interval_day(){
		for day in 1...64 {
			let diff = day - 1
			let intervalDay = diff % 64 + 1
			XCTAssert(intervalDay == day)
		}
	}
	
	func test_firstWeekDue(){
		let due1 = boxCtr.getLevels(fromDayDiff: 0)
		let due2 = boxCtr.getLevels(fromDayDiff: 1)
		let due3 = boxCtr.getLevels(fromDayDiff: 2)
		let due4 = boxCtr.getLevels(fromDayDiff: 3)
		let due5 = boxCtr.getLevels(fromDayDiff: 4)
		let due6 = boxCtr.getLevels(fromDayDiff: 5)
		let due7 = boxCtr.getLevels(fromDayDiff: 6)
		let due8 = boxCtr.getLevels(fromDayDiff: 7)

		XCTAssertEqual(due1, Set([1]), "🐙 Failed: Day 1 has incorrect levels.")
		XCTAssertEqual(due2, Set([1]), "🐙 Failed: Day 2 has incorrect levels.")
		XCTAssertEqual(due3, Set([2,1]), "🐙 Failed: Day 3 has incorrect levels.")
		XCTAssertEqual(due4, Set([1]), "🐙 Failed: Day 4 has incorrect levels.")
		XCTAssertEqual(due5, Set([2, 1]), "🐙 Failed: Day 5 has incorrect levels.")
		XCTAssertEqual(due6, Set([3, 1]), "🐙 Failed: Day 6 has incorrect levels.")
		XCTAssertEqual(due7, Set([2, 1]), "🐙 Failed: Day 7 has incorrect levels.")
		XCTAssertEqual(due8, Set([1]), "🐙 Failed: Day 8 has incorrect levels.")

	}
	
	func test_firstCycle_Exceptions(){
		let due1 = boxCtr.getLevels(fromDayDiff: 0)
		let due2 = boxCtr.getLevels(fromDayDiff: 1)
		let due4 = boxCtr.getLevels(fromDayDiff: 3)
		let due12 = boxCtr.getLevels(fromDayDiff: 11)
		let due24 = boxCtr.getLevels(fromDayDiff: 23)
		let due56 = boxCtr.getLevels(fromDayDiff: 55)

		XCTAssertEqual(due1, Set([1]), "🐙 Failed: Day 1 has incorrect levels.")
		XCTAssertEqual(due2, Set([1]), "🐙 Failed: Day 2 has incorrect levels.")
		XCTAssertEqual(due4, Set([1]), "🐙 Failed: Day 4 has incorrect levels.")
		XCTAssertEqual(due12, Set([1]), "🐙 Failed: Day 12 has incorrect levels.")
		XCTAssertEqual(due24, Set([1]), "🐙 Failed: Day 24 has incorrect levels.")
		XCTAssertEqual(due56, Set([1]), "🐙 Failed: Day 56 has incorrect levels.")
	}

	func test_secondCycle_Exceptions(){
		let oneCycle = 64
		let due1 = boxCtr.getLevels(fromDayDiff: oneCycle + 0)
		let due2 = boxCtr.getLevels(fromDayDiff: oneCycle + 1)
		let due4 = boxCtr.getLevels(fromDayDiff: oneCycle + 3)
		let due12 = boxCtr.getLevels(fromDayDiff: oneCycle + 11)
		let due24 = boxCtr.getLevels(fromDayDiff: oneCycle + 23)
		let due56 = boxCtr.getLevels(fromDayDiff: oneCycle + 55)

		XCTAssertEqual(due1, Set([2,1]), "🐙 Failed: Day 1 has incorrect levels.")
		XCTAssertEqual(due2, Set([3,1]), "🐙 Failed: Day 2 has incorrect levels.")
		XCTAssertEqual(due4, Set([4,1]), "🐙 Failed: Day 4 has incorrect levels.")
		XCTAssertEqual(due12, Set([5, 1]), "🐙 Failed: Day 12 has incorrect levels.")
		XCTAssertEqual(due24, Set([6, 1]), "🐙 Failed: Day 24 has incorrect levels.")
		XCTAssertEqual(due56, Set([7, 1]), "🐙 Failed: Day 56 has incorrect levels.")
	}
	
	func test_getLevels_FromDate(){
		guard let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date()) else { XCTFail(); return }
		guard let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: Date()) else { XCTFail(); return }

		let allDue = boxCtr.getLevels(at: threeDaysAgo, startDate: fiveDaysAgo)
		XCTAssertEqual(allDue, Set([2,1]))

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
		

		let yesterdayLevels = boxCtr.getLevels(at: yesterday, startDate: startDate)
		XCTAssert(yesterdayLevels == Set([1]) )
		
		let box = Box(startDate: startDate, latestStudyDate: yesterday, latestLevels: Array(yesterdayLevels), allDue: Array(yesterdayLevels), dayDone: true)
		
		let diffSinceStarted = DateHelper.getDayDiff(from: startDate, to: Date())
		XCTAssertEqual(diffSinceStarted, 12)
		
		let dueTodayExclusively = boxCtr.getExclusiveDues(startDate: startDate, day: today)
		XCTAssertEqual(dueTodayExclusively, Set([4,2,1]))
		
		let diff = DateHelper.getDayDiff(from: box.latestStudyDate, to: Date())
		XCTAssertEqual(diff, 1)
		

		
		let _ = boxCtr.getLevels(fromBox: box) { (dayDone, allDues) in
			// should be updated to what we should study today
			XCTAssertFalse(dayDone)
			XCTAssertFalse(box.dayDone)
			XCTAssertEqual(allDues, Set([4,2,1]))
			let isSetupToday = Calendar.current.isDateInToday(box.setupDate)
			XCTAssert(isSetupToday)
		}
	}
	
	// test fetching level from a box that was studied yesterday but didn't complete all levels

}
