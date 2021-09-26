//
//  Box.swift
//  minibox
//
//  Created by Anne on 27/9/20.
//

import Foundation

/// Imitation of a box in the cloud
class Box {
	var startDate: Date
	var latestStudyDate: Date
	var setupDate: Date
	var latestLevels: [Int] = []
	var allDue: [Int] = []
	
	/// whether all the levels were studied at the last studied date
	var dayDone: Bool
	
	/// Box initializer for a new box that user never began studying before
	init(startDate: Date) {
		self.startDate = startDate
		self.latestStudyDate = startDate
		self.dayDone = false
		self.setupDate = startDate
		self.allDue = [1] // only level 1 is due on the first day
	}
	
	/// Initialization for users that has already started tracking a box with paper
	init(startDate: Date, latestStudyDate: Date, latestLevels: [Int], allDue: [Int], dayDone: Bool) {
		let startDateMidnight = Calendar.current.startOfDay(for: startDate)
		self.startDate = startDateMidnight
		self.latestStudyDate = latestStudyDate
		self.latestLevels = latestLevels
		self.dayDone = dayDone
		self.allDue = allDue
		self.setupDate = latestStudyDate
	}
}

