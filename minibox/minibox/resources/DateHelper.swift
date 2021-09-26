//
//  DateHelper.swift
//  minibox
//
//  Created by Anne on 9/12/20.
//

import Foundation

struct DateHelper {
	/// MM/DD  eg. 08/09 for August 9
	static func shortDateString(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd"
		return dateFormatter.string(from: date)
	}
	
	/// eg. Nov 23, 1937
	static func mediumDateString(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		return dateFormatter.string(from: date)
	}
	
	/// eg. August 9
	static func beautyDateString(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd"
		return dateFormatter.string(from: date)
	}
	
	/// yyyy-MM-dd h:mm a
	static func longDateString(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
		return dateFormatter.string(from: date)
	}
	
	/// h:mm a
	static func timeString(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a"
		return dateFormatter.string(from: date)
	}
	
	/// get the difference of days, each date's time will be set at midnight
	static func getDayDiff(from startDate: Date, to endDate: Date) -> Int {
		let startDateMidnight = Calendar.current.startOfDay(for: startDate)
		let endDateMidnight = Calendar.current.startOfDay(for: endDate)
		
		let dayDiff = Calendar.current.dateComponents([.day], from: startDateMidnight, to: endDateMidnight).day
		
		if dayDiff == nil {
			print("\n🍰 daydiff is nil.")
		}
		
		return dayDiff ?? 0
	}
	
}
