//
//  PerMeView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI
import AuthenticationServices


struct PerMeView: View {
	
	@Environment(\.colorScheme) var colorScheme
	
	@AppStorage("email") var email : String = ""
	@AppStorage("firstName") var firstName : String = ""
	@AppStorage("lastName") var lastName : String = ""
	@AppStorage("userId") var userId : String = ""
	
	
	var body: some View {
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

struct PerMeView_Previews: PreviewProvider {
	static var previews: some View {
		PerMeView()
		
	}
}
