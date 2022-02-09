//
//  Order.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation

class Order: ObservableObject, Codable, Identifiable {
	
	enum CodingKeys: CodingKey{
		case id, products, business, user, date_time, order_status, code_to_collect
	}
	
	@Published var id : String = ""
	@Published var products = [Product]()
	@Published var business: Business = Business.defaultBusiness
	@Published var user: User = User()
	@Published var date_time: String = ""
	@Published var order_status: OrderStatus = OrderStatus.composing
	@Published var code_to_collect: String = ""
	
	@Published var alertOtherBusinessMessage = ""
	@Published var showingAlertOtherBusiness = false
	
	@Published var alertModifiedOrderMessage = ""
	@Published var showingAlertModifiedOrder = false
	
	@Published var showingAlertAlcohol = false
	
	
	func dismissAlert(){
		DispatchQueue.main.async {
			self.showingAlertOtherBusiness = false
		}
		
	}
	
	
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
				self.alertOtherBusinessMessage = "Stai già effettuando un altro ordine da \(self.business.business_name)"
				self.showingAlertOtherBusiness = true
			}
		}
	}
	
	func checkBeginningAnotherOrder(newOrder : Order) -> Bool {
		if self.business != Business.defaultBusiness {
			return true
		}
		else {
			return false
		}
	}
	
	func removeProduct(product: Product){
		if let index = self.products.firstIndex(of: product){
			self.products.remove(at: index)
		}
		
		// removing products, if in products list there are no more elements
		// then, reset the business for the next order
		if self.products.count == 0 {
			self.business = Business.defaultBusiness
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
	
	func buildNewOrderFromOldOrder(order: Order){
		if !checkBeginningAnotherOrder(newOrder: order) {
			self.products = order.products
			self.business = order.business
			self.alertModifiedOrderMessage = "Vai nel tab Ordine e procedi con il pagamento"
			self.showingAlertModifiedOrder = true
		}
		else{
			self.alertOtherBusinessMessage = "Stai già effettuando un altro ordine da \(self.business.business_name)"
			self.showingAlertOtherBusiness = true
		}
	}
	
	func getTotal() -> Double {
		var total: Double = 0
		for product in products {
			total += product.price
		}
		return total
	}
	
	func setUser(user: User){
		self.user = user
	}
	
	func setDateTime(date_time: String){
		self.date_time = date_time
	}
	
	func emptyOrder(){
		DispatchQueue.main.async {
			self.id = ""
			self.products = [Product]()
			self.business = Business.defaultBusiness
			self.user = User()
			self.date_time = ""
		}
	}
	
	func containsAlcoholicProducts() -> Bool {
		for product in products {
			if product.stamps.contains(Stamps.alcoholic){
				return true
			}
		}
		return false
	}
	
	init() { }
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(id, forKey: .id)
		try container.encode(products, forKey: .products)
		try container.encode(business, forKey: .business)
		try container.encode(user, forKey: .user)
		try container.encode(date_time, forKey: .date_time)
		try container.encode(order_status, forKey: .order_status)
		try container.encode(code_to_collect, forKey: .code_to_collect)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(String.self, forKey: .id)
		products = try container.decode([Product].self, forKey: .products)
		business = try container.decode(Business.self, forKey: .business)
		user = try container.decode(User.self, forKey: .user)
		date_time = try container.decode(String.self, forKey: .date_time)
		order_status = try container.decode(OrderStatus.self, forKey: .order_status)
		code_to_collect = try container.decode(String.self, forKey: .code_to_collect)
	}
	
	
}
