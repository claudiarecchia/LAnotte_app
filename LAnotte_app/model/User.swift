//
//  User.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation

class User: Codable, Identifiable {
    
    var id: String?
    var email: String?
    var password: String?
	var favourite_products : [String: [Product]]?
	
	
	init(id: String, email: String, password: String, fav_prod: [String: [Product]]){
        self.id = id
        self.email = email
        self.password = password
		self.favourite_products = fav_prod
    }
	
	// if user is a guest (not logged)
	init(id: String){
		self.id = id
	}
	
	init(){ }
	
	func AddFavouriteProduct(business : Business, product : Product){
		var newList : [Product] = []
		// newList = favourite_products![business.business_name]!.append(product)
		
		for el in favourite_products![business.business_name]!{
			newList.append(el)
		}
		newList.append(product)
		
		if let oldValue = favourite_products!.updateValue(newList, forKey: business.business_name) {
			print("The old value of \(oldValue) was replaced with a new one.")
		} else {
			print("No value was found in the dictionary for that key.")
		}
		for el in favourite_products!{
			print(el)
		}
	}
	
}
