//
//  Order.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation

class Order{
    
    var id: Int
    var hour: String
    var date: String
    var estimated_hour: String
    var state: String
    var products: Array<Product>
    var business: Business
    var user: User
    
    init(id: Int, hour: String, date: String, estimated_hour: String, state: String, products: Array<Product>, business: Business, user: User) {
        self.id = id
        self.hour = hour
        self.date = date
        self.estimated_hour = estimated_hour
        self.state = state
        self.products = products
        self.business = business
        self.user = user
    }
    
    
}
