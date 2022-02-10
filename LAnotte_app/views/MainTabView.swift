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
			ForMeView()
				.tabItem {
					Image(systemName: "arrow.clockwise.heart")
					Text("Per me")
				}
			ArchiveView()
				.tabItem {
					Image(systemName: "tray")
					Text("Archivio")
				}
			
			OrderView()
				.tabItem {
					Image(systemName: "bag")
					Text("Ordine")
				}
			
			InfoView()
				.tabItem {
					Image(systemName: "info.circle.fill")
					Text("Info")
				}
		}.onAppear{
		
			if user.isLoggedIn {
				Task {
					await user.UserAttributes(user: user)
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
