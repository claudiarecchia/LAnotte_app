//
//  MainTabView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct MainTabView: View {
	
	@EnvironmentObject var user : User
	
	var body: some View {
		
		TabView{
			NavigationView{
				HomeView()
					.navigationBarHidden(true)
			}.tabItem {
				Image(systemName: "house")
				Text("Home")
			}
			PerMeView()
				.tabItem {
					Image(systemName: "arrow.clockwise.heart")
					Text("Per me")
				}
			ArchivioView()
				.tabItem {
					Image(systemName: "tray")
					Text("Archivio")
				}
			
			OrderView()
				.tabItem {
					Image(systemName: "bag")
					Text("Ordine")
				}
		}.onAppear{
			user.IsLoggedIn()
			if user.isLoggedIn {
				Task {
					await user.FavouriteProducts(user: user)
				}
			}
		}
	}
}


struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView().environmentObject(Order()).environmentObject(User())
	}
}
