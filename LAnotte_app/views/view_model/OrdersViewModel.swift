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
		if user.id != nil {
			DispatchQueue.main.async{
				order.user = user
			}
		}
			
		DispatchQueue.main.async{
			// add date to order
			order.date_time = getCurrentDateTimeString()
		}
		
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
				
				if user.id == nil {
					// user.login(user: (decodedOrder.first?.user)!)
				}
				
//				DispatchQueue.main.async {
//					self.confirmationMessage = "Testo sottotitolo"
//					self.showingConfirmation = true
//					print("OK")
//				}
			}
		} catch {
			print("Checkout failed")
		}
	}
	
//	func makePayment(order : Order){
//		let paymentItem = PKPaymentSummaryItem.init(label: "ordine", amount: NSDecimalNumber(value: order.getTotal()))
//		let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
//		if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
//
//			let request = PKPaymentRequest()
//				request.currencyCode = "EUR" // 1
//				request.countryCode = "IT" // 2
//				request.merchantIdentifier = "merchant.it.demo.tesi.lanotteapp" // 3
//				request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
//				request.supportedNetworks = paymentNetworks // 5
//				request.paymentSummaryItems = [paymentItem] // 6
//
//			guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
//			// displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
//			print("Unable to present Apple Pay authorization.")
//			return
//		}
//			// paymentVC.delegate = self
//			self.present(paymentVC, animated: true, completion: nil)
//
//		} else {
//			print("Unable to make Apple Pay transaction")
//			// displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
//		}
//	}
	
	
}
