//
//  User.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation
import SwiftUI

class User: Codable, Identifiable, ObservableObject {
	
	enum CodingKeys: CodingKey{
		case id, apple_id, favourite_products, ratings
	}
	
    var id: String?
	var apple_id: String?
	
	@Published var isLoggedIn : Bool = false
	@Published var favourite_products : [String: [Product]]?
	@Published var ratings : [String: Int]?
	
	func IsLoggedIn(){
//		let user = KeychainHelper.standard.read(service: "user", account: "lanotte", type: User.self)
//		print("check logged in", user)
//		if user != nil {
//			print("user not nil")
//				self.isLoggedIn = true
//				self.id = user!.id
//		}
//		print("user is logged in: " , self.isLoggedIn)
		
	}
	
	init(id: String, fav_prod: [String: [Product]], ratings : [String : Int]){
        self.id = id
		self.favourite_products = fav_prod
		self.ratings = ratings
    }
	
	// if user is a guest (not logged)
	init(id: String){
		self.id = id
	}
	
	init(){ }

	
	 func AppleLogin(apple_id : String) async {
		// self.setID(apple_id: apple_id)
		
		Task {
			await self.UserAttributes(user: self)
			DispatchQueue.main.async{
				print(self.apple_id)
				print(self.favourite_products)
				print(self.ratings)
				KeychainHelper.standard.save(self, service: "user", account: "lanotte")
				self.isLoggedIn = true
			}
		}
	}
	
	func setID(apple_id : String){
		self.apple_id = apple_id
		print("QUI" , self.apple_id)

	}
	
	func readKeychain() -> User{
		let user = KeychainHelper.standard.read(service: "user", account: "lanotte", type: User.self)
		return user!
	}
	
	func logout(){
		KeychainHelper.standard.delete(service: "user", account: "lanotte")
		self.id = ""
		self.favourite_products = [:]
		self.ratings = [:]
		self.isLoggedIn = false
	}
	
	func setFavProducts(products: [String : [Product]]){
		self.favourite_products = products
	}
	
	func removeFavouriteProduct(business : Business, product : Product){
		if let index = self.favourite_products![business.business_name]!.firstIndex(of: product){
			self.favourite_products![business.business_name]!.remove(at: index)
		}
	}
	
	func setRating(order : Order, rating : Int){
		self.ratings![order.business.business_name] = rating
	}
	
	func getNumberFavouriteProducts() -> Bool {
//		Array(user.favourite_products!.keys).sorted(), id: \.self) { business in
//			ForEach(user.favourite_products![business]!) { item in
		
		var notEmptyDict = false
		
		let list = Array(self.favourite_products!.keys).sorted()
		for business in list {
			if self.favourite_products![business] != nil {
				notEmptyDict = true
			}
		}
		return notEmptyDict
	}
	
	// MARK: - API CALLS
	func AddFavouriteProduct(business : Business, product : Product){
		var newList : [Product] = []

		if self.favourite_products![business.business_name] != nil {
			for el in self.favourite_products![business.business_name]!{
				newList.append(el)
			}
			
			if !(self.favourite_products![business.business_name]!.contains(product)){
				newList.append(product)
			}
		}
		
		// business_name to add as key
		else{
			self.favourite_products![business.business_name] = newList
			newList.append(product)
		}
		
		if let oldValue = self.favourite_products!.updateValue(newList, forKey: business.business_name) {
			// print("The old value of \(oldValue) was replaced with a new one.")
		} else {
			// print("No value was found in the dictionary for that key.")
		}

	}
	
	func UserAttributes(user : User) async {
			// add user to request
			guard let encoded = try? JSONEncoder().encode(user) else{
				print("Failed to encode user")
				return
			}
			
			let url = URL(string: base_server_uri + "getUser")!
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-type")
			request.httpMethod = "POST"

			do{
				let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
				// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
				if let decoded = try? JSONDecoder().decode([User].self, from: data){
					DispatchQueue.main.async {
						if decoded.count > 0 {
							self.favourite_products = decoded[0].favourite_products!
							self.ratings = decoded[0].ratings!
							self.id = decoded[0].id
						}
					}
				}
			} catch {
				print("Checkout failed")
			}
		
	}
	
	func saveMyRating(user : User) async {
		// add user to request
		guard let encoded = try? JSONEncoder().encode(user) else{
			print("Failed to encode user")
			return
		}
		let url = URL(string: base_server_uri + "saveRatings")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		do{
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if let decoded = try? JSONDecoder().decode([User].self, from: data){
				DispatchQueue.main.async {
					if decoded.count > 0 {
						self.ratings = decoded[0].ratings!
					}
				}
			}
		} catch {
			print("Checkout failed")
		}
	}
	
	func saveMyFavourites(user: User) async {
		// add user to request
		guard let encoded = try? JSONEncoder().encode(user) else{
			print("Failed to encode user")
			return
		}
		let url = URL(string: base_server_uri + "saveFavourites")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		do{
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if let decoded = try? JSONDecoder().decode([User].self, from: data){
				DispatchQueue.main.async {
					if decoded.count > 0 {
						self.favourite_products = decoded[0].favourite_products!
					}
				}
			}
		} catch {
			print("Checkout failed")
		}
	}
	
	// MARK: - CODABLE PROTOCOL
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(id, forKey: .id)
		try container.encode(apple_id, forKey: .apple_id)
		try container.encode(favourite_products, forKey: .favourite_products)
		try container.encode(ratings, forKey: .ratings)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(String.self, forKey: .id)
		apple_id = try container.decode(String.self, forKey: .apple_id)
		favourite_products = try container.decode([String : [Product]].self, forKey: .favourite_products)
		ratings = try container.decode([String : Int].self, forKey: .ratings)
	}
	
}
