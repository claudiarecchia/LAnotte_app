//
//  OrderStatus.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/02/22.
//

import Foundation

enum OrderStatus: String, Codable {
	case composing = ""
	case placed = "placed"
	case preparing = "preparing"
	case prepared = "prepared"
	case collected = "collected"
}
