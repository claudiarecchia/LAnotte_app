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
	
	@Environment(\.colorScheme) var colorScheme
	
	//	@AppStorage("email") var email : String = ""
	//	@AppStorage("firstName") var firstName : String = ""
	//	@AppStorage("lastName") var lastName : String = ""
	//	@AppStorage("userId") var userId : String = ""
	
	
	var body: some View {
		
		VStack{
			if user.isLoggedIn{
				VStack{
					
					Text("Per me")
						.font(.title3)
						.padding(.top, 2)
					
					VStack(alignment: .leading){
						
						List(Array(user.favourite_products!.keys).sorted(), id: \.self) { business in
							ForEach(user.favourite_products![business]!) { item in
									
									var business = localiViewModel.getBusinessObjectFromString(business_name: business)
										
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
														AddRemoveFavouriteView(business: business, item: item, user: user)
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
						
					}
//					.padding()
//					.background(Color.blue)
//					.cornerRadius(20)
//					.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
					
					Spacer()
				}
				
				Button {
					user.logout()
				} label: {
					Text("Logout")
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
					
					//					SignInWithAppleButton(.continue){ request in
					//
					//						request.requestedScopes = [.email, .fullName]
					//
					//					}
					//
					//				onCompletion: { result in
					//
					//					switch result {
					//					case .success(let auth):
					//						switch auth.credential {
					//						case let credentials as ASAuthorizationAppleIDCredential:
					//							let userId = credentials.user
					//
					//							let email = credentials.email
					//							let firstName = credentials.fullName?.givenName
					//							let lastName = credentials.fullName?.familyName
					//
					//							self.email = email ?? ""
					//							self.firstName = firstName ?? ""
					//							self.lastName = lastName ?? ""
					//							self.userId = userId
					//
					//							print(userId)
					//							print(email)
					//							print(firstName)
					//							print(lastName)
					//
					//						default:
					//							break
					//						}
					//
					//					case .failure(let error): print(error)
					//					}
					//
					//
					//				}
					//				.frame(height: 50)
					//				.padding()
					//				.cornerRadius(8)
					//				.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
				}
			}
			
		}
		.onAppear {
//			user.IsLoggedIn()
//			Task{
//				await userViewModel.FavouriteProducts(user: user)
//			}
			localiViewModel.loadData(path: "allBusinesses", method: "GET")
		}
	}
}

struct PerMeView_Previews: PreviewProvider {
	static var previews: some View {
		PerMeView().environmentObject(User()).environmentObject(Order())
		
	}
}
