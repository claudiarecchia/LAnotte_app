//
//  AddRemoveFavouriteView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 29/12/21.
//

import SwiftUI

struct AddRemoveFavouriteView: View {
	
	var business : Business
	var item : Product
	var user : User
	
	var body: some View {
		let list = user.favourite_products![business.business_name]
		if (list != nil && list!.contains(item)) {
			Button {
				user.removeFavouriteProduct(business: business, product: item)
				Task{
					await user.saveMyFavourites(user: user)
				}
			} label: {
				Image(systemName: "heart.fill")
					.foregroundColor(.red)
			}
		}
		else{
			Button {
				user.AddFavouriteProduct(business: business, product: item)
				Task{
					await user.saveMyFavourites(user: user)
				}
			} label: {
				Image(systemName: "heart")
					.foregroundColor(.red)
			}
		}
	}
}

struct AddRemoveFavouriteView_Previews: PreviewProvider {
	static var previews: some View {
		AddRemoveFavouriteView(business: Business.defaultBusiness, item: Product.defaultProduct, user: User())
	}
}
