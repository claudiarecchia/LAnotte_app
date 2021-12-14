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
	
	@Published var confirmationMessage = ""
	@Published var showingConfirmation = false
	
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
	
	
	func placeOrder(order: Order) async{
		// add user to order
		let user = KeychainHelper.standard.read(service: "user",
												  account: "lanotte",
												  type: User.self)
		if user != nil {
			//DispatchQueue.main.async{
				// order.setUser(user: user!)
				order.user = user!
			//}
			
		}
		
		// add date to order
		//DispatchQueue.main.async{
			// order.setDateTime(date_time: Date().formatted(date: .numeric, time: .shortened))
			order.date_time = Date().formatted(date: .numeric, time: .shortened)
		//	print(order.date_time)
		//}
		
		guard let encoded = try? JSONEncoder().encode(order) else{
			print("Failed to encode order")
			return
		}
		
		let url = URL(string: base_server_uri + "placeOrder")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		
		do{
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if let decodedOrder = try? JSONDecoder().decode([Order].self, from: data){
				
				if user == nil {
					KeychainHelper.standard.save(decodedOrder.first?.user, service: "user", account: "lanotte")
				}
				
				DispatchQueue.main.async {
					self.confirmationMessage = "Testo sottotitolo"
					self.showingConfirmation = true
					print("OK")
				}
			}
		} catch {
			print("Checkout failed")
		}
	}

	
}
