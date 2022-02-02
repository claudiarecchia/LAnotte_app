//
//  PerMeView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI
import AuthenticationServices


struct PerMeView: View {
	
	@StateObject private var ordersViewModel = OrdersViewModel()
	@StateObject private var localiViewModel = LocaliViewModel()
	
	@EnvironmentObject var user: User
	@EnvironmentObject var order: Order
	
	@State private var anyFavourite : Bool = false
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		
		VStack{
			if user.isLoggedIn{
				VStack{
					Text("Per me")
						.font(.title3)
						.padding(.top, 2)
					
					if (user.getNumberFavouriteProducts()) {
						VStack(alignment: .leading){
							
							List(Array(user.favourite_products!.keys).sorted(), id: \.self) { business in
								ForEach(user.favourite_products![business]!) { item in
									
									var business = localiViewModel.getBusinessObjectFromString(business_name: business)
									
									VStack(alignment: .leading, spacing: 8){
										HStack{
											
											LAnotteRoundedImageView(image: item.image, dimension: 70)
											
											VStack(alignment: .leading, spacing: 3) {
												
												LAnotteProductNameAndStampsView(item: item)
												
												HStack{
													Text(item.category)
														.font(.subheadline)
														.fontWeight(.light)
													
													Spacer()
													
													if user.isLoggedIn {
														AddRemoveFavouriteView(business: business, item: item, user: user)
													}
												}
											}
										}
										LAnotteProductPriceView(item: item)
										
										LAnotteAlcoholContentView(item: item)
										
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
							
						}
					}
					
					else {
						Spacer()
						
						Text("Aggiungi prodotti ai preferiti per vederli qui e aggiungerli agli ordini più velocemente")
							.padding()
							.multilineTextAlignment(.center)
							.foregroundColor(.gray)
							.frame(maxWidth: .infinity)
					}
					
					
					Spacer()
				}
			}
			else{
				VStack{
					Spacer()
					
					Text("Effettua il login per ottenere suggerimenti per i prossimi ordini")
						.padding()
						.multilineTextAlignment(.center)
						.foregroundColor(.gray)
					
					Spacer()
					SignInWithAppleButton(.continue){ request in
						request.requestedScopes = [.email]
					}
				onCompletion: { result in
					switch result {
					case .success(let auth):
						switch auth.credential {
						case let credentials as ASAuthorizationAppleIDCredential:
							let userId = credentials.user
							user.apple_id = userId
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
		.onAppear {
			Task {
				await localiViewModel.loadData(path: "allBusinesses", method: "GET")
			}
		}
	}
}

struct PerMeView_Previews: PreviewProvider {
	static var previews: some View {
		PerMeView().environmentObject(User()).environmentObject(Order())
	}
}
