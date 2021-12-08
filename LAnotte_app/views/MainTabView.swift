//
//  MainTabView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct MainTabView: View {
	
	var body: some View {
		
		TabView{
			NavigationView{
				HomeView()
					.navigationBarHidden(true)
			}.tabItem {
				Image(systemName: "house")
				Text("Home")
			}
			SecondView()
				.tabItem {
					Image(systemName: "arrow.clockwise.heart")
					Text("Per me")
				}
			ThirdView()
				.tabItem {
					Image(systemName: "tray")
					Text("Archivio")
				}
			
			OrderView()
				.tabItem {
					Image(systemName: "bag")
					Text("Ordine")
				}
		}
	}
}


struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView().environmentObject(Order())
	}
}
