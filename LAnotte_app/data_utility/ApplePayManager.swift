//
//  ApplePayManager.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 29/12/21.
//

import Foundation

import PassKit

final class ApplePayManager: NSObject {
	// MARK: - PROPERTIES
	var itemCost: Double
	var order : Order
	var user : User
	var ordersViewModel : OrdersViewModel
	var status : PKPaymentAuthorizationStatus

	private lazy var paymentRequest: PKPaymentRequest = {
		let request: PKPaymentRequest = PKPaymentRequest()
		let item = PKPaymentSummaryItem(label: "Ordine da \(order.business.business_name)", amount: NSDecimalNumber(integerLiteral: Int(itemCost)))
		
		request.merchantIdentifier = "merchant.it.demo.tesi.lanotteapp"
		request.countryCode = "IT"
		request.currencyCode = "EUR"
		request.merchantCapabilities = .capability3DS
		request.paymentSummaryItems = [item]
		request.supportedNetworks = [.maestro, .masterCard, .visa]

		// request.applicationData = PKPaymentToken.paymentData

		return request
	}()
	
	func buyBtnTapped() {
		print("PAYMENT REQ:", paymentRequest)
		guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest),
		   // let window = SwiftHelper.getSceneDelegate()?.window
			  let window = UIApplication.shared.connectedScenes
									  .filter({$0.activationState == .foregroundActive})
									  .map({$0 as? UIWindowScene})
									  .compactMap({$0})
									  .first?.windows
						  .filter({$0.isKeyWindow}).first
		else {
			return
		}
		paymentVC.delegate = self
		window.rootViewController?.present(paymentVC, animated: true, completion: nil)
	}
	
	
	// MARK: - LIFE CYCLE METHODS
	init(itemCost: Double, order : Order, user : User, ordersViewModel : OrdersViewModel) {
		self.itemCost = itemCost
		self.order = order
		self.user = user
		self.ordersViewModel = ordersViewModel
		self.status = .failure
	}
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate
extension ApplePayManager: PKPaymentAuthorizationViewControllerDelegate {
	
	func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
		controller.dismiss(animated: true, completion: nil)
		if self.status == .success {
			Task{
				print("Placing order")
				
				order.setDateTime(date_time: getCurrentDateTimeString())
				if user.isLoggedIn {
					let storedUser = user.readKeychain()
						order.setUser(user: storedUser)
				}
				
				await ordersViewModel.placeOrder(order: order, user: user)
			}
		}
	}
	
	func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
		completion(.init(status: .success, errors: nil))
		self.status = .success
	}

	
}

