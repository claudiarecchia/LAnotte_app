//
//  ThirdView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct ArchivioView: View {
	
	@State private var isLoggedIn : Bool = false
	@State private var isLoading : Bool = false
	@State private var orders : [Order] = [Order]()
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack{
			if isLoggedIn{
				VStack{
					Text("Archivio ordini")
						.font(.title3)
						.padding(.top, 2)
					ZStack{
						if isLoading{ ProgressView() }
						
						List(orders, id: \.id){ order in
							ForEach(Array(Set(order.products))) { product in
								VStack(alignment: .leading, spacing: 4){
									
									HStack(spacing: 5){
										Image(systemName: "checkmark.seal")
										Text(order.business.business_name)
											.fontWeight(.semibold)
									}
									
									HStack{
										Text(convertStringToDate(dateTime: order.date_time).formatted(date: .numeric, time: .omitted))
											.font(.subheadline)
											.fontWeight(.light)
										Text(convertStringToDate(dateTime: order.date_time).formatted(date: .omitted, time: .shortened))
											.font(.subheadline)
											.fontWeight(.light)
									}
									
									HStack{
										Text("\(order.getQuantityProductInOrder(product: product))x")
										Text(product.name)
										Text("€\(String(format: "%.2f", product.price))")
									}
									.padding(.top, 3)
									.padding(.bottom, 3)
									
									Text("Totale €\((String(format: "%.2f", order.getTotal())))")
								}
							}
						}
					}
				}
			}
			else{
				Spacer()
				
				Text("Effettua il login vedere lo storico dei tuoi ordini")
					.padding()
					.multilineTextAlignment(.center)
					.foregroundColor(.gray)
				
				Spacer()
			}
		}
		
		.background(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
		.onAppear {
			Task{
				await LoggedIn()
			}
			
		}
	}
	func LoggedIn() async {
		let result = KeychainHelper.standard.read(service: "user",
												  account: "lanotte",
												  type: User.self)
		
		print("check logged in")
		if result != nil {
			self.isLoggedIn = true
			await loadData(path: "archive", method: "POST", user: result!)
		}
	}
	
	func loadData(path: String, method: String, user: User) async {
		
		self.isLoading = true
		guard let encoded = try? JSONEncoder().encode(user) else{
			print("Failed to encode order")
			return
		}
		
		let url = URL(string: base_server_uri + "archive")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		
		do{
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
			if let decodedOrder = try? JSONDecoder().decode([Order].self, from: data){
				// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
				DispatchQueue.main.async {
					self.isLoading = false
					self.orders = decodedOrder
				}
			}
		} catch {
			print("Checkout failed")
		}
	}
	
}

struct ArchivioView_Previews: PreviewProvider {
	static var previews: some View {
		ArchivioView()
	}
}
