//
//  LAnotteProductIngredientsView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 08/12/21.
//

import SwiftUI

struct LAnotteProductIngredientsView : View{
	
	var item: Product
	
	var body: some View{
		
		HStack{
			Image(systemName: "list.bullet")
			
			Text(item.ingredients.joined(separator: ", "))
				.lineLimit(3)
				.minimumScaleFactor(0.5)
				.font(.caption)
		}
	}
}

struct ProductIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
		LAnotteProductIngredientsView(item: Product.defaultProduct)
    }
}
