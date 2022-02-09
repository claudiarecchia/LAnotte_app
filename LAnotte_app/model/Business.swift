//
//  Business.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/12/21.
//

import Foundation

struct Business: Identifiable, Codable, Hashable, Comparable{
	
	static func < (lhs: Business, rhs: Business) -> Bool {
		lhs.business_name < rhs.business_name
	}
    
    let id: String
    let business_name: String
    let description: String
	let image: String
    let location: String
    let rating: Double
    let products: [Product]
	let opening_houres: [String : [String]]

	
	static let defaultBusiness = Business(id: "", business_name: "", description: "", image: "", location: "", rating: 0, products: [], opening_houres: ["": [""]] )

}

struct BusinessResponse: Codable{
    let request: [Business]
}
