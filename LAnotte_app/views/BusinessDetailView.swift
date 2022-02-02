//
//  BusinessDetailView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 07/12/21.
//

import SwiftUI

struct BusinessDetailView: View {
	
	@EnvironmentObject var order: Order
	@EnvironmentObject var user: User
	@StateObject private var localiViewModel = LocaliViewModel()
	
	@State var business: Business = Business.defaultBusiness
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		NavigationView{
			List {
				Section{
					VStack(alignment:.center, spacing: 6){
						LAnotteRoundedImageView(image: business.image, dimension: 90)
						
						Text(business.business_name)
							.font(.title2)
							.bold()
						
						if (business.description != ""){
							Text(business.description)
								.fontWeight(.light)
								.lineLimit(2)
								.minimumScaleFactor(0.5)
								.font(.callout)
								.multilineTextAlignment(.center)
						}
						
						BusinessRatingStarsView(business: business)
						
						HStack{
							Image(systemName: "clock")
							if !(localiViewModel.isClosingDay(business: business)){
								Text(business.opening_houres[String(Date().dayNumberOfWeek())]![0] + " - " + business.opening_houres[String(Date().dayNumberOfWeek())]![1])
									.fontWeight(.light)
							}
							else {
								Text("Giorno di chiusura")
							}
							
						}
					}
					.frame(maxWidth: .infinity, alignment: .center)				
					.listRowBackground(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
				}
				
				ForEach(business.products){ item in
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
							order.addProduct(product: item, product_business: business)
							
						} onDecrement: {
							order.removeProduct(product: item)
						}
					}
				}
			}.hiddenNavigationBarStyle()
				.alert("Attenzione! Prodotto non aggiunto", isPresented: $order.showingAlertOtherBusiness) {
					Button("OK") {
					}
			 } message: {
				 Text(order.alertOtherBusinessMessage)
			 }
		}
	}
}

struct BusinessRatingStarsView : View {
	
	var business: Business
	
	var body: some View{
		HStack{
			ForEach(0..<Int(business.rating)) { _ in
				Image(systemName: "star.fill")
			}
			if (Int(business.rating) < 5){
				if (business.rating.truncatingRemainder(dividingBy: 2) != 0){
					Image(systemName: "star.leadinghalf.filled")
				}
			}
			if Int(business.rating) + Int(business.rating.truncatingRemainder(dividingBy: 2)) < 5 {
				ForEach(Int(business.rating + business.rating.truncatingRemainder(dividingBy: 2))..<5) { _ in
					Image(systemName: "star")
				}
			}
		}
	}
}

struct BusinessDetailView_Previews: PreviewProvider {
	static var previews: some View {
		BusinessDetailView(business: Business.defaultBusiness).environmentObject(Order()).environmentObject(User())
	}
}
