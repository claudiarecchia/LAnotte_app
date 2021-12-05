//
//  Product.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation
import CoreVideo

class Product{
    
    var id: String?
    var name: String?
    var ingredients: Array<String>?
    // var image: Data?
    var image: String?
    var category: String?
    var stamps: Array<String>?
    
    init(id: String, name: String, ingredients: Array<String>, image: String, category: String, stamps: Array<String>){
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.image = image
        self.category = category
        self.stamps = stamps
    }
    
    init(){}
    
}
