//
//  UserViewModel.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 22/12/21.
//

import Foundation

final class UserViewModel : ObservableObject {
	
	@Published var user: User = User()
	@Published var favouriteProducts : [String : [Product]] = [:]
	@Published var isLogged = false
	
	
	func LoggedIn(){
		let result = KeychainHelper.standard.read(service: "user", account: "lanotte", type: User.self)
		print("check logged in")
		if result != nil {
			self.isLogged = true
//			self.user.id = result!.id
//			self.user.favourite_products = result!.favourite_products
		}
	}
	
	func FavouriteProducts() async {
		if self.isLogged {
			// add user to request
			let user = KeychainHelper.standard.read(service: "user",
													account: "lanotte",
													type: User.self)
			
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
				print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
				if let decoded = try? JSONDecoder().decode([User].self, from: data){
					
					DispatchQueue.main.async {
						if decoded.count > 0 {
							self.favouriteProducts = decoded[0].favourite_products!
						}
					}
				}
			} catch {
				print("Checkout failed")
			}
			
		}
		
		func CheckProductIsPreferred(product : Product) -> Bool {
			let result = self.favouriteProducts.contains{ (value) -> Bool in
				value as? Product == product
			}
			return result
		}
		
		func addFavouriteProduct(product : Product) {
			// add product to favourites
			
			
			
			// add user to request
			let user = KeychainHelper.standard.read(service: "user",
													account: "lanotte",
													type: User.self)
			
			guard let encoded = try? JSONEncoder().encode(user) else{
				print("Failed to encode user")
				return
			}
			
			
		}
		
		
		
	}
	
	
	
	
}
