//
//  Business.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation

class Bus{
    
    var id: Int
    var business_name: String
    var VAT_number: Int
    var description: String
    var image: Data
    var location: String
    var rating: Double
    var products: Array<Product>
    
    init(id: Int, business_name: String, VAT_number: Int, description: String, image: Data, location: String, rating: Double, products: Array<Product>) {
        self.id = id
        self.business_name = business_name
        self.VAT_number = VAT_number
        self.description = description
        self.image = image
        self.location = location
        self.rating = rating
        self.products = products
    }
    
}
