//
//  OrdersViewModel.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 13/12/21.
//

import Foundation
import SwiftUI
import PassKit

final class OrdersViewModel : ObservableObject {
	
	@Published var orders: [Order] = []
	@Published var isLoading = true
	@Published var isLoggedIn = false
	
	@Published var confirmationMessage = ""
	@Published var showingConfirmation = false
	
	let userDefaults = UserDefaults.standard
	
	func getOrdersToCollect(){
		var number = 0
		for order in orders {
			if order.order_status == OrderStatus.prepared {
				number = number+1
			}
		}
		UIApplication.shared.applicationIconBadgeNumber = number
	}
	
	
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
	
	func placeOrder(order: Order, user : User) async {
		
		guard let encoded = try? JSONEncoder().encode(order) else{
			print("Failed to encode order")
			return
		}
		let url = URL(string: base_server_uri + "placeOrder")!
		var request = URLRequest(url: url)
		// print("TOKEN : " , userDefaults.value(forKey: "deviceToken"))
		let token = userDefaults.value(forKey: "deviceToken") ?? ""
		request.addValue(token as! String, forHTTPHeaderField: "Authorization")
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		do{
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if (try? JSONDecoder().decode([Order].self, from: data)) != nil{
				order.emptyOrder()
			}
		} catch {
			print("Checkout failed")
		}
	}
}
