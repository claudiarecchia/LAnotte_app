//
//  DateConverter.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 13/12/21.
//

import Foundation

func convertStringToDate(dateTime : String) -> Date {
	let dateFormatter = DateFormatter()
	dateFormatter.locale = Locale(identifier: "it_IT")
	dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
	let date = dateFormatter.date(from: dateTime)
	
	let calendar = Calendar.current
	let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date!)
	let finalDate = calendar.date(from:components)
	
	return finalDate!
}

func getCurrentDateTimeString() -> String {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
	let date = dateFormatter.string(from: Date())
	return date
}

extension Date {
	func dayNumberOfWeek() -> Int {
		let numDay = Calendar.current.dateComponents([.weekday], from: self).weekday
		
		var toReturn = 0
		
		// weekday goes from 1 (sunday) to 7 (saturday)
		// this is a way to convert into italian convention 0 (monday) to 6 (sunday)
		switch numDay {
		case 1:
			toReturn = 6
		case 2:
			toReturn = 0
		case 3:
			toReturn = 1
		case 4:
			toReturn = 2
		case 5:
			toReturn = 3
		case 6:
			toReturn = 4
		case 7:
			toReturn = 5
		default:
			toReturn = 0
		}
		return toReturn
	}
}
