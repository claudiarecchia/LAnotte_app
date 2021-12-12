//
//  OrderView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct OrderView: View {
	
	@State private var confirmationMessage = ""
	@State private var showingConfirmation = false
	
	@EnvironmentObject var order: Order
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
			
				Section{
					Button {
						Task{
							await placeOrder()
						}
					} label: {
						Text("Conferma ordine")
							.padding()
							.foregroundColor(.white)
							.background(.blue)
							.cornerRadius(8)
					}
					.frame(maxWidth: .infinity, alignment: .center)
					.listRowBackground(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
				}
			}
			.alert("Ordine confermato", isPresented: $showingConfirmation) {
				Button("OK") { }
		 } message: {
		   Text(confirmationMessage)
		 }
		}
		else {
			Text("Inserisci prodotti nell'ordine per visualizzarli qui")
			                .padding()
			                .multilineTextAlignment(.center)
			                .foregroundColor(.gray)
		}
	}
	func placeOrder() async{
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
				
				KeychainHelper.standard.save(decodedOrder.first?.user, service: "user", account: "lanotte")
				
				// print(decodedOrder.first?.user.id!)
				let result = KeychainHelper.standard.read(service: "user",
														  account: "lanotte",
														  type: User.self)!
				
				print(result.id)
				confirmationMessage = "Sottotitolo"
				showingConfirmation = true
				print("OK")
			}
		} catch {
			print("Checkout failed")
		}
	}
}




struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView().environmentObject(Order())
	}
}
