//
//  ContentView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView{
            FirstView()
                .tabItem {
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
                    Text("Storico ordini")
                }
            
            FourthView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Ordine")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
