//
//  LAnotteAlcoholContentView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 02/02/22.
//

import SwiftUI

struct LAnotteAlcoholContentView: View {
	
	var item : Product
	
	var body: some View {
		if item.stamps.contains(Stamps.alcoholic){
			VStack(alignment: .leading, spacing: 3){
				HStack{
					Image(systemName: "hand.raised.circle")
					
					Text(String(item.alcoholContent) + "%VOL")
						.font(.subheadline)
						.fontWeight(.light)
				}
			}
		}
	}
}

struct LAnotteAlcoholContentView_Previews: PreviewProvider {
	static var previews: some View {
		LAnotteAlcoholContentView(item: Product.defaultProduct)
	}
}
