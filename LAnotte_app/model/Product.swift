//
//  Product.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/12/21.
//

import Foundation

struct Product: Identifiable, Codable {
    
    let id: String
    let name: String
    let ingredients: [String]
    // var image: Data?
    let image: String
    let category: String
    let stamps: [String]
    
}

struct ProductResponse: Codable {
    let request: [Product]
}
