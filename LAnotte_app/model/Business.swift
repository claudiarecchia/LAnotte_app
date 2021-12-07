//
//  Business.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/12/21.
//

import Foundation

struct Business: Identifiable, Codable {
    
    let id: String
    let business_name: String
    let VAT_number: String
    let description: String
    let image: String
    let location: String
    let rating: Double
    let products: [Product]
    
    static let defaultBusiness = Business(id: "", business_name: "", VAT_number: "", description: "", image: "", location: "", rating: 0, products: [] )
    
}

struct BusinessResponse: Codable{
    let request: [Business]
}
