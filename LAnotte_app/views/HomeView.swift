//
//  HomeView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct HomeView: View {
	
	@State var index = 0
	
	var body: some View {
		VStack{
			HStack(){
				Text("Locali")
					.foregroundColor(self.index == 0 ? .white : .blue.opacity(0.7))
					.padding(.vertical, 10)
					.padding(.horizontal, 50)
					.background(.blue.opacity(self.index == 0 ? 1 : 0))
					.clipShape(Capsule())
					.onTapGesture {
						withAnimation(.default){
							self.index = 0
						}
					}
				Spacer(minLength: 0)
				Text("Prodotti")
					.foregroundColor(self.index == 1 ? .white : .blue.opacity(0.7))
					.padding(.vertical, 10)
					.padding(.horizontal, 50)
					.background(.blue.opacity(self.index == 1 ? 1 : 0))
					.clipShape(Capsule())
					.onTapGesture {
						withAnimation(.default){
							self.index = 1
						}
					}
			}
			.padding(.horizontal)
			
			TabView(selection: self.$index){
				BusinessesView().tag(0)
				ProductsView().tag(1)
			}.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			
			Spacer(minLength: 0)
			
		}.background(Color.black.opacity(0.06))
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
