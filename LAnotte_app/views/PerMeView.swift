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
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		
		VStack{
			if ordersViewModel.isLoggedIn{
				VStack{
					
					Text("Per me")
						.font(.title3)
						.padding(.top, 2)
					
					VStack(alignment: .leading){
						
						Text("Rieffettua l'ultima ordinazione")
							.fontWeight(.bold)
							.foregroundColor(.white)
						
						
						
						Text(ordersViewModel.lastOrder.business.business_name)
							.fontWeight(.semibold)
							.foregroundColor(.white)
							
						ForEach(ordersViewModel.lastOrder.products) { item in
							Text(item.name)
								.foregroundColor(.white)
							
						}
					}
					.padding()
					.background(Color.blue)
					.cornerRadius(20)
					.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
					
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
					
					//			SignInWithAppleButton(.continue){ request in
					//
					//				request.requestedScopes = [.email, .fullName]
					//
					//			}
					//
					//			onCompletion: { result in
					//
					//				switch result {
					//				case .success(let auth):
					//					switch auth.credential {
					//					case let credentials as ASAuthorizationAppleIDCredential:
					//						let userId = credentials.user
					//
					//						let email = credentials.email
					//						let firstName = credentials.fullName?.givenName
					//						let lastName = credentials.fullName?.familyName
					//
					//						self.email = email ?? ""
					//						self.firstName = firstName ?? ""
					//						self.lastName = lastName ?? ""
					//						self.userId = userId
					//
					//					default:
					//						break
					//					}
					//
					//				case .failure(let error): print(error)
					//				}
					//
					//
					//		}
					//		.frame(height: 50)
					//		.padding()
					//		.cornerRadius(8)
					//		.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
				}
			}
			
		}
		.onAppear {
			Task{
				ordersViewModel.LoggedIn()
				await ordersViewModel.LastProduct()
			}
			
		}
	}
}

struct PerMeView_Previews: PreviewProvider {
	static var previews: some View {
		PerMeView()
		
	}
}
