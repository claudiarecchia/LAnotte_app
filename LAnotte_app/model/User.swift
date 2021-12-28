//
//  User.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation

class User: Codable, Identifiable, ObservableObject {
	
	enum CodingKeys: CodingKey{
		case id, favourite_products
	}
	
    var id: String?
//    var email: String?
//    var password: String?
//	var favourite_products : [String: [Product]]?
	
	@Published var isLoggedIn : Bool = false
	@Published var favourite_products : [String: [Product]]?
	
	func IsLoggedIn(){
		let user = KeychainHelper.standard.read(service: "user", account: "lanotte", type: User.self)
		print("check logged in", user)
		if user != nil {
			print("user not nil")
			// DispatchQueue.main.async {
				self.isLoggedIn = true
				self.id = user!.id
				//self.favourite_products = user!.favourite_products
			//}
		}
		print(self.isLoggedIn)
		print(self.favourite_products)
		
	}
	
	init(id: String, fav_prod: [String: [Product]]){
        self.id = id
//        self.email = email
//        self.password = password
		self.favourite_products = fav_prod
    }
	
	// if user is a guest (not logged)
	init(id: String){
		self.id = id
	}
	
	init(){ }
	
	func login(user : User){
		KeychainHelper.standard.save(user, service: "user", account: "lanotte")
		self.id = user.id
		self.favourite_products = user.favourite_products
	}
	
	func logout(){
		KeychainHelper.standard.delete(service: "user", account: "lanotte")
		self.id = ""
		self.favourite_products = [:]
	}
	
	func setFavProducts(products: [String : [Product]]){
		self.favourite_products = products
		print("UPATED: ", self.favourite_products)
	}
	
	func AddFavouriteProduct(business : Business, product : Product){
		print("my fav products ", self.favourite_products)
		var newList : [Product] = []
		// newList = favourite_products![business.business_name]!.append(product)
		// for el in favourite_products![business.business_name]!{
		
		for el in self.favourite_products![business.business_name]!{
			newList.append(el)
		}
		newList.append(product)
		
		if let oldValue = self.favourite_products!.updateValue(newList, forKey: business.business_name) {
			print("The old value of \(oldValue) was replaced with a new one.")
		} else {
			print("No value was found in the dictionary for that key.")
		}
		for el in self.favourite_products!{
			print(el)
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(id, forKey: .id)
		try container.encode(favourite_products, forKey: .favourite_products)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(String.self, forKey: .id)
		favourite_products = try container.decode([String : [Product]].self, forKey: .favourite_products)
	}
	
}
