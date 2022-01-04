//
//  OrderView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI
import PassKit

struct OrderView: View {
	
	@StateObject private var ordersViewModel = OrdersViewModel()
	@EnvironmentObject var order: Order
	@EnvironmentObject var user: User
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		
		if order.products != [Product]() {
			VStack{
				List{
					Section{
						
						VStack(alignment:.center, spacing: 6){
							
							Text("Il mio ordine da")
								.font(.title3)
							
							Text(order.business.business_name)
								.font(.title2)
								.bold()
							
							LAnotteRoundedImageView(image: "business", dimension: 90)
							
						}
						.frame(maxWidth: .infinity, alignment: .center)
						.listRowBackground(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
						
					}
					
					ForEach(Array(Set(order.products)).sorted()){ item in
						VStack(alignment: .leading, spacing: 8){
							HStack{
								LAnotteRoundedImageView(image: "mule-mug-rame", dimension: 70)
								
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
				
				let applePay = ApplePayManager(itemCost: order.getTotal(), order: order, user: user, ordersViewModel: ordersViewModel)
				if colorScheme == .dark {
					iPaymentButton(type: .buy, style: .white) {
						applePay.buyBtnTapped()
					}
					.padding(.bottom, 4)
				}
				else {
					iPaymentButton(type: .buy, style: .black) {
						applePay.buyBtnTapped()
					}
					.padding(.bottom, 4)
				}
			}
			//			.alert("Ordine confermato", isPresented: $ordersViewModel.showingConfirmation) {
			//				Button("OK") {
			//					order.emptyOrder()
			//				}
			//			} message: {
			//				Text(ordersViewModel.confirmationMessage)
			//			}
		}
		else {
			Text("Inserisci prodotti nell'ordine per visualizzarli qui")
				.padding()
				.multilineTextAlignment(.center)
				.foregroundColor(.gray)
		}
	}
}




struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView().environmentObject(Order()).environmentObject(User())
	}
}
