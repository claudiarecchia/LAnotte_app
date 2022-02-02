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
		VStack(alignment: .leading, spacing: 3){
			HStack{
				Image(systemName: "hand.raised.circle")
				if item.stamps.contains("alcoholic"){
					Text(item.alcohol_content + "%VOL")
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
