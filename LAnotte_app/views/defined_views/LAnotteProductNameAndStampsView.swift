//
//  LAnotteProductNameAndStampsView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 08/12/21.
//

import SwiftUI

struct LAnotteProductNameAndStampsView: View {
	
	var item: Product
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View{
		HStack{
			Text(item.name)
				.fontWeight(.semibold)
			
			Spacer()
			
			if item.stamps.contains(Stamps.alcoholic){
				if colorScheme == .light {
					Image("18+_black")
						.resizable()
						.scaledToFit()
						.frame(height: 19)
				}
				if colorScheme == .dark {
					Image("18+_white")
						.resizable()
						.scaledToFit()
						.frame(height: 19)
				}
			}
			if item.stamps.contains(Stamps.vegan){
				Image(systemName: "leaf.fill")
			}
			if item.stamps.contains(Stamps.gluten_free){
				if colorScheme == .light {
					Image("gluten-free")
						.resizable()
						.scaledToFit()
						.frame(height: 19)
				}
				if colorScheme == .dark {
					Image("gluten-free-dark-mode")
						.resizable()
						.scaledToFit()
						.frame(height: 19)
				}
			}
		}
	}
}

struct LAnotteProductNameAndStampsView_Previews: PreviewProvider {
	static var previews: some View {
		LAnotteProductNameAndStampsView(item: Product.defaultProduct)
	}
}
