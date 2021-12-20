//
//  ThirdView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct ArchivioView: View {
	
	@StateObject private var ordersViewModel = OrdersViewModel()
	@State private var orders : [Order] = [Order]()
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack{
			if ordersViewModel.isLoggedIn{
				VStack{
					Text("Archivio ordini")
						.font(.title3)
						.padding(.top, 2)
					ZStack{
						if ordersViewModel.isLoading{ ProgressView() }
						
						List(ordersViewModel.orders, id: \.id){ order in
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
				VStack{
					Spacer()
					
					Text("Effettua il login vedere lo storico dei tuoi ordini")
						.padding()
						.multilineTextAlignment(.center)
						.foregroundColor(.gray)
						.frame(maxWidth: .infinity)
					Spacer()
				}
				
			}
		}
		.background(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
		.onAppear {
			Task{
				ordersViewModel.LoggedIn()
				await ordersViewModel.GetMyOrders()
			}
			
		}
	}
}

struct ArchivioView_Previews: PreviewProvider {
	static var previews: some View {
		ArchivioView()
	}
}
