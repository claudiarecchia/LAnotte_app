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
