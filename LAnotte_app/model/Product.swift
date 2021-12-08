//
//  Product.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/12/21.
//

import Foundation

struct Product: Identifiable, Codable, Equatable, Hashable {
    
    let id: String
    let name: String
    let ingredients: [String]
    // var image: Data?
    let image: String
    let category: String
    let stamps: [String]
	let price: Double
	
	static let defaultProduct = Product(id: "", name: "", ingredients: [], image: "", category: "", stamps: [], price: 0)
    
}


struct ProductResponse: Codable {
    let request: [Product]
}
