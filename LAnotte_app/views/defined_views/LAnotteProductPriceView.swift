//
//  LAnotteProductPriceView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 08/12/21.
//

import SwiftUI

struct LAnotteProductPriceView: View {
	
	var item: Product
	
    var body: some View {
		
		HStack{
			Image(systemName: "eurosign.circle")
			Text((String(format: "%.2f", item.price)))
				.font(.subheadline)
				.fontWeight(.light)
		}
    }
	
}

struct LAnotteProductPriceView_Previews: PreviewProvider {
    static var previews: some View {
		LAnotteProductPriceView(item: Product.defaultProduct)
    }
}
