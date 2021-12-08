//
//  OrderView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct OrderView: View {
	
	@EnvironmentObject var order: Order
	
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
					.listRowBackground(Color(.secondarySystemBackground))
					
				}
				
				ForEach(Array(Set(order.products))){ item in
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
							order.addProduct(product: item, product_business: order.business)
						} onDecrement: {
							order.removeProduct(product: item)
						}
					}
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
		OrderView().environmentObject(Order())
	}
}
