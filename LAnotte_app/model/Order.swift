//
//  Order.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation

class Order: ObservableObject {
	
	@Published var products = [Product]()
	var business: Business = Business.defaultBusiness
    
//    var id: String?
//    var hour: String?
//    var date: String?
//    var estimated_hour: String?
//    var state: String?
//    var products: [Product]?
//    var business: Business?
//    var user: User?

    
    func addProduct(product: Product, product_business: Business){
		if business.business_name == Business.defaultBusiness.business_name {
			self.business = product_business
			self.products.append(product)
		}
		else{
			if self.business.business_name == product_business.business_name{
				self.products.append(product)
			}
			// selected a product of another business -- not allowed
			else{
				#warning("AGGIUNGERE ALERT IN CASO DI SELEZIONE PRODOTTO DA UN'ALTRA AZIENDA")
			}
		}
	}
    
    func removeProduct(product: Product){
        if let index = self.products.firstIndex(of: product){
            self.products.remove(at: index)
        }
    }
	
	func getQuantityProductInOrder(product: Product) -> Int {
		var counts: Int = 0

		for item in products {
			if item == product {
				counts += 1
			}
		}
		return counts
	}
    
    
}
