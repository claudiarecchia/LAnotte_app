//
//  Product.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/12/21.
//

import Foundation

struct Product: Identifiable, Codable, Equatable, Hashable, Comparable {
	
	static func < (lhs: Product, rhs: Product) -> Bool {
		lhs.name < rhs.name
	}
	
    
    let id: String
    let name: String
    let ingredients: [String]
    let image: String
    let category: String
    let stamps: [Stamps]
	let price: Double
	let alcohol_content: String
	
	//static let defaultProduct = Product(id: "", name: "", ingredients: [], image: "", category: "", stamps: [], price: 0)
	static let defaultProduct = Product(id: "", name: "", ingredients: [], image: "", category: "", stamps: [], price: 0, alcohol_content: "")
 
}


struct ProductResponse: Codable {
    let request: [Product]
}
