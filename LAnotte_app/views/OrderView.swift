//
//  OrderView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI
import PassKit
import AuthenticationServices

struct OrderView: View {
	
	@StateObject private var ordersViewModel = OrdersViewModel()
	@EnvironmentObject var order: Order
	@EnvironmentObject var user: User
	
	@State private var showingAlert = false
	@State private var preauthorized = false
	@State private var justPlacedOrder = false
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		ZStack{
			if order.products.count > 0{
				VStack{
					List{
						Section{
							
							VStack(alignment:.center, spacing: 6){
								
								Text("Il mio ordine da")
									.font(.title3)
								
								Text(order.business.business_name)
									.font(.title2)
									.bold()
								
								LAnotteRoundedImageView(image: order.business.image, dimension: 90)
								
							}
							.frame(maxWidth: .infinity, alignment: .center)
							.listRowBackground(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
							
						}
						
						ForEach(Array(Set(order.products)).sorted()){ item in
							VStack(alignment: .leading, spacing: 8){
								HStack{
									LAnotteRoundedImageView(image: item.image, dimension: 70)
									
									VStack(alignment: .leading, spacing: 3){
										LAnotteProductNameAndStampsView(item: item)
										
										HStack{
											Text(item.category)
												.font(.subheadline)
												.fontWeight(.light)
											
											Spacer()
											
											if user.isLoggedIn {
												let list = user.favourite_products?[order.business.business_name]
												if (list != nil && list!.contains(item)) {
													Button {
														user.removeFavouriteProduct(business: order.business, product: item)
														Task{
															await user.saveMyFavourites(user: user)
														}
													} label: {
														Image(systemName: "heart.fill")
															.foregroundColor(.red)
													}
													.buttonStyle(GrowingButton())
												}
												else{
													Button {
														user.AddFavouriteProduct(business: order.business, product: item)
														Task{
															await user.saveMyFavourites(user: user)
														}
													} label: {
														Image(systemName: "heart")
															.foregroundColor(.red)
													}
													.buttonStyle(GrowingButton())
												}
											}
										}
									}
								}
								
								LAnotteProductPriceView(item: item)
								
								LAnotteAlcoholContentView(item: item)
								
								LAnotteProductIngredientsView(item: item)
								
								Stepper {
									Text("Aggiunti all'ordine: \(order.getQuantityProductInOrder(product: item)) ")
								} onIncrement: {
									order.addProduct(product: item, product_business: order.business)
								} onDecrement: {
									order.removeProduct(product: item)
								}
							}
						}
					}
					
					Spacer()
					
					Text("Totale ordine € \((String(format: "%.2f", order.getTotal())))")
						.font(.headline)
					
					// if user is logged, then can process the order
					if user.isLoggedIn {
						// if order contains alcoholic products, a preauthorization is required
						if (order.containsAlcoholicProducts()) && (!preauthorized){
							Button {
								showingAlert = true
							} label: {
								Text("Procedi al pagamento")
									.frame(minWidth: 0, maxWidth: .infinity)
									.frame(height: 40)
									.font(.system(size: 16))
									.foregroundColor(.white)
							}
							.background(.blue)
							.cornerRadius(8)
							.frame(minWidth: 100, maxWidth: 300)
							.alert(isPresented:$showingAlert) {
								Alert(
									title: Text("Nell'ordine sono presenti prodotti contenenti alcol"),
									message: Text("Conferma di essere maggiorenne per completare l'acquisto."),
									primaryButton: .default(Text("Modifica ordine")) {
										print("Modifica ordine")
									},
									secondaryButton: .destructive(Text("Sono maggiorenne")) {
										print("Sono maggiorenne")
										self.preauthorized = true
									}
								)
							}
						}
						else {
							
							let applePay = ApplePayManager(itemCost: order.getTotal(), order: order, user: user, ordersViewModel: ordersViewModel)
							if colorScheme == .dark {
								
								iPaymentButton(type: .buy, style: .white) {
									self.showingAlert = false
									applePay.buyBtnTapped()
									self.justPlacedOrder = true
								}
								.padding(.bottom, 4)
							}
							else {
								iPaymentButton(type: .buy, style: .black) {
									self.showingAlert = false
									applePay.buyBtnTapped()
									self.justPlacedOrder = true
								}
								.padding(.bottom, 4)
							}
						}
					}
					
					// otherwise, if the user is not logged will we required the authentication
					else {
						SignInWithAppleButton(.continue){ request in
							request.requestedScopes = [.email]
						}
					onCompletion: { result in
						switch result {
						case .success(let auth):
							switch auth.credential {
							case let credentials as ASAuthorizationAppleIDCredential:
								let userId = credentials.user
								user.login_id = userId
								Task {
									await user.AppleLogin(apple_id: userId)
								}
								
							default:
								break
							}
							
						case .failure(let error): print(error)
						}
					}
					.frame(height: 40)
					.frame(minWidth: 100, maxWidth: 300)
					.cornerRadius(8)
					.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
					}
				}
			}
			
			
			
			else {
				if (!self.justPlacedOrder){
					Text("Inserisci prodotti nell'ordine per visualizzarli qui")
						.padding()
						.multilineTextAlignment(.center)
						.foregroundColor(.gray)
				}
				else {
					Text("Grazie! Il tuo ordine è stato inviato al locale.\nNel tab Archivio puoi monitorarne lo stato.")
						.padding()
						.multilineTextAlignment(.center)
						.foregroundColor(.gray)
				}
				
			}
			
		}
		.onAppear{
			self.justPlacedOrder = false
		}
		
	}
	
}




struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView().environmentObject(Order()).environmentObject(User())
	}
}
