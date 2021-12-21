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
	
	@State private var searchString = ""
	
	var body: some View {
		VStack{
			
			LAnotteSearchBar(text: $searchString, placeholderText: "Cerca il nome di un prodotto")
			
			Form{
				ForEach(localiViewModel.businesses) { business in
					List(searchString == "" ? business.products: business.products.filter { $0.name.contains(searchString)}, id: \.self) { item in
						
						VStack(alignment: .leading, spacing: 8){
							HStack{
								
								LAnotteRoundedImageView(image: "mule-mug-rame", dimension: 70)
								
								VStack(alignment: .leading, spacing: 3) {
									
									LAnotteProductNameAndStampsView(item: item)
									
									Text(item.category)
										.font(.subheadline)
										.fontWeight(.light)
									
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
		ProdottiView().environmentObject(Order())
	}
}
