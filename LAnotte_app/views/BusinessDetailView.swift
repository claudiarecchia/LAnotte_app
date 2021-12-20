//
//  BusinessDetailView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 07/12/21.
//

import SwiftUI

struct BusinessDetailView: View {
	
	@EnvironmentObject var order: Order
	@State var business: Business = Business.defaultBusiness
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		NavigationView{
			List {
				Section{
					VStack(alignment:.center, spacing: 6){
						LAnotteRoundedImageView(image: "business", dimension: 90)
						
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
							Text("20:00 - 02:00")
								.fontWeight(.light)
						}
					}
					.frame(maxWidth: .infinity, alignment: .center)				
					.listRowBackground(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
				}
				
				ForEach(business.products){ item in
					VStack(alignment: .leading, spacing: 8){
						HStack{
							LAnotteRoundedImageView(image: "mule-mug-rame", dimension: 70)
							
							VStack(alignment: .leading, spacing: 3){
								LAnotteProductNameAndStampsView(item: item)
								
								Text(item.category)
									.font(.subheadline)
									.fontWeight(.light)
							}
						}
						
						LAnotteProductPriceView(item: item)
						
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
						order.emptyOrder()
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
			if (business.rating.truncatingRemainder(dividingBy: 2) != 0){
				Image(systemName: "star.leadinghalf.filled")
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
		BusinessDetailView(business: Business.defaultBusiness).environmentObject(Order())
	}
}
