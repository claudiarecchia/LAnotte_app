//
//  OrdersViewModel.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 13/12/21.
//

import Foundation
import SwiftUI

final class OrdersViewModel : ObservableObject {
	
	@Published var orders: [Order] = []
	@Published var isLoading = true
	@Published var isLoggedIn = false
	
	@Published var confirmationMessage = ""
	@Published var showingConfirmation = false

	
	func loadData(path: String, method: String, user: User) async {
		self.isLoading = true
		guard let encoded = try? JSONEncoder().encode(user) else{
			// print("Failed to encode user")
			return
		}
		
		let url = URL(string: base_server_uri + path)!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		
		do{
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if let decodedOrder = try? JSONDecoder().decode([Order].self, from: data){
				print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
				DispatchQueue.main.async {
					self.isLoading = false
					self.orders = decodedOrder
				}
			}
		} catch {
			print("Checkout failed")
		}
	}
	
//	func LastProduct() async {
//		// add user to order
//		let user = KeychainHelper.standard.read(service: "user",
//												account: "lanotte",
//												type: User.self)
//
//
//		guard let encoded = try? JSONEncoder().encode(user) else{
//			print("Failed to encode user")
//			return
//		}
//
//		let url = URL(string: base_server_uri + "lastOrder")!
//		var request = URLRequest(url: url)
//		request.setValue("application/json", forHTTPHeaderField: "Content-type")
//		request.httpMethod = "POST"
//
//		do{
//			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
//			print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
//			if let decodedOrder = try? JSONDecoder().decode([Order].self, from: data){
//
//				DispatchQueue.main.async {
//					if decodedOrder.count > 0{
//						self.lastOrder = decodedOrder[0]
//					}
//				}
//			}
//		} catch {
//			print("Checkout failed")
//		}
//
//	}
	
	
	func placeOrder(order: Order, user : User) async {
		if user.id != nil {
			order.user = user
		}
			
		// add date to order
		order.date_time = getCurrentDateTimeString()
		
		
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
			print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if let decodedOrder = try? JSONDecoder().decode([Order].self, from: data){
				
				if user.id == nil {
					user.login(user: (decodedOrder.first?.user)!)
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
