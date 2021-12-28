//
//  UserViewModel.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 22/12/21.
//

import Foundation

final class UserViewModel : ObservableObject {
	
	@Published var favouriteProducts : [String : [Product]] = [:]
	
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
							self.favouriteProducts = decoded[0].favourite_products!
							// user.favourite_products = self.favouriteProducts
							user.setFavProducts(products: self.favouriteProducts)
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
						self.favouriteProducts = decoded[0].favourite_products!
						// user.favourite_products = self.favouriteProducts
						user.setFavProducts(products: self.favouriteProducts)
					}
				}
			}
		} catch {
			print("Checkout failed")
		}
	}
}

