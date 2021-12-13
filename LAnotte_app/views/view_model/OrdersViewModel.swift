//
//  OrdersViewModel.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 13/12/21.
//

import Foundation

final class OrdersViewModel : ObservableObject {
	
	@Published var orders: [Order] = []
	@Published var isLoading = true
	@Published var isLoggedIn = false
	
	func LoggedIn() async {
		let result = KeychainHelper.standard.read(service: "user", account: "lanotte", type: User.self)
		print("check logged in")
		if result != nil {
			self.isLoggedIn = true
			await loadData(path: "archive", method: "POST", user: result!)
		}
	}
	
	func loadData(path: String, method: String, user: User) async {
		self.isLoading = true
		guard let encoded = try? JSONEncoder().encode(user) else{
			// print("Failed to encode user")
			return
		}
		
		let url = URL(string: base_server_uri + "archive")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		
		do{
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if let decodedOrder = try? JSONDecoder().decode([Order].self, from: data){
				// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
				DispatchQueue.main.async {
					self.isLoading = false
					self.orders = decodedOrder
				}
			}
		} catch {
			print("Checkout failed")
		}
	}
	
}
