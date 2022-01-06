//
//  ProdottiView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct ProdottiView: View {
	
	@StateObject private var localiViewModel = LocaliViewModel()
	
	@EnvironmentObject var order : Order
	@EnvironmentObject var user : User
	
	@State private var searchString = ""
	
	var body: some View {
		VStack{
			
			LAnotteSearchBar(text: $searchString, placeholderText: "Cerca il nome di un prodotto")
			
			Form{
				ForEach(localiViewModel.businesses) { business in
					List(searchString == "" ? business.products: business.products.filter { $0.name.containsIgnoringCase(searchString)}, id: \.self) { item in
						
						VStack(alignment: .leading, spacing: 8){
							HStack{
								
								LAnotteRoundedImageView(image: "mule-mug-rame", dimension: 70)
								
								VStack(alignment: .leading, spacing: 3) {
									
									LAnotteProductNameAndStampsView(item: item)
									
									HStack{
										Text(item.category)
											.font(.subheadline)
											.fontWeight(.light)
										
										Spacer()
										
										if user.isLoggedIn {
												let list = user.favourite_products?[business.business_name]
												if (list != nil && list!.contains(item)) {
													Button {
														user.removeFavouriteProduct(business: business, product: item)
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
														user.AddFavouriteProduct(business: business, product: item)
														Task{
															await user.saveMyFavourites(user: user)
														}
													} label: {
														Image(systemName: "heart")
															.foregroundColor(.red)
													}
													.buttonStyle(GrowingButton())
												}
											// AddRemoveFavouriteView(userViewModel: userViewModel, business: business, item: item, user: user)
										}
									}
									
									
								}
							}
							
							LAnotteProductPriceView(item: item)
							
							ProductBusiness(business: business)
							
							LAnotteProductIngredientsView(item: item)
							
							Stepper {
								Text("Aggiunti all'ordine: \(order.getQuantityProductInOrder(product: item)) ")
							} onIncrement: {
								order.addProduct(product: item, product_business: business)
							} onDecrement: {
								order.removeProduct(product: item)
							}
						}
					}
				}
			}.onAppear {
				localiViewModel.loadData(path: "allBusinesses", method: "GET")
			}
		}
		
	}
}

struct ProductBusiness : View{
	
	var business: Business
	
	var body: some View{
		
		HStack{
			Image(systemName: "checkmark.seal")
			Text(business.business_name)
				.font(.subheadline)
				.fontWeight(.light)
		}
	}
}

struct ProdottiView_Previews: PreviewProvider {
	static var previews: some View {
		ProdottiView().environmentObject(Order()).environmentObject(User())
	}
}
