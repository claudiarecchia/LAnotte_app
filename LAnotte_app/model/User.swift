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
		print("user is logged in: " , self.isLoggedIn)
		
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
	}
	
	func removeFavouriteProduct(business : Business, product : Product){
		if let index = self.favourite_products![business.business_name]!.firstIndex(of: product){
			self.favourite_products![business.business_name]!.remove(at: index)
		}
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
	
	func FavouriteProducts(user : User) async {
		if user.isLoggedIn {
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
						}
					}
				}
			} catch {
				print("Checkout failed")
			}
			
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
		try container.encode(favourite_products, forKey: .favourite_products)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(String.self, forKey: .id)
		favourite_products = try container.decode([String : [Product]].self, forKey: .favourite_products)
	}
	
}
