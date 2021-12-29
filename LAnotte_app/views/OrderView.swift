//
//  OrderView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct OrderView: View {

	@StateObject private var ordersViewModel = OrdersViewModel()
	@StateObject private var userViewModel = UserViewModel()
	@EnvironmentObject var order: Order
	@EnvironmentObject var user: User
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		
		if order.products != [Product]() {
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
										let list = userViewModel.favouriteProducts[order.business.business_name]
											if (list != nil && list!.contains(item)) {
												Button {
													user.removeFavouriteProduct(business: order.business, product: item)
													Task{
														await userViewModel.saveMyFavourites(user: user)
														await userViewModel.FavouriteProducts(user: user)
													}
												} label: {
													Image(systemName: "heart.fill")
														.foregroundColor(.red)
												}
											}
											else{
												Button {
													user.AddFavouriteProduct(business: order.business, product: item)
													Task{
														await userViewModel.saveMyFavourites(user: user)
														await userViewModel.FavouriteProducts(user: user)
													}
												} label: {
													Image(systemName: "heart")
														.foregroundColor(.red)
												}
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
			
				Section{
					Button {
						Task{
							await ordersViewModel.placeOrder(order: order, user: user)
						}
					} label: {
						Text("Conferma ordine € \((String(format: "%.2f", order.getTotal())))")
							.padding()
							.foregroundColor(.white)
							.background(.blue)
							.cornerRadius(8)
					}
					.frame(maxWidth: .infinity, alignment: .center)
					.listRowBackground(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
				}
			}
			.alert("Ordine confermato", isPresented: $ordersViewModel.showingConfirmation) {
				Button("OK") {
					order.emptyOrder()
				}
		 } message: {
			 Text(ordersViewModel.confirmationMessage)
		 }
		 .onAppear{
			 user.IsLoggedIn()
			 Task{
				 await userViewModel.FavouriteProducts(user: user)
			 }
		 }
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
