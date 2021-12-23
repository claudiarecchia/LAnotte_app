//
//  ArchivioView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct ArchivioView: View {
	
	@StateObject private var ordersViewModel = OrdersViewModel()
	@State private var orders : [Order] = [Order]()
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var order: Order
	
	var body: some View {
		VStack{
			if ordersViewModel.isLoggedIn{
				VStack{
					Text("Archivio ordini")
						.font(.title3)
						.padding(.top, 2)
					ZStack{
						if ordersViewModel.isLoading{ ProgressView() }
						
						List(ordersViewModel.orders, id: \.id){ archived_order in
							ForEach(Array(Set(archived_order.products))) { product in
								VStack(alignment: .leading, spacing: 4){
									
									HStack(spacing: 5){
										Image(systemName: "checkmark.seal")
										Text(archived_order.business.business_name)
											.fontWeight(.semibold)
									}
									
									HStack{
										Text(convertStringToDate(dateTime: archived_order.date_time).formatted(date: .numeric, time: .omitted))
											.font(.subheadline)
											.fontWeight(.light)
										Text(convertStringToDate(dateTime: archived_order.date_time).formatted(date: .omitted, time: .shortened))
											.font(.subheadline)
											.fontWeight(.light)
									}
									
									HStack{
										Text("\(archived_order.getQuantityProductInOrder(product: product))x")
										Text(product.name)
										Text("€\(String(format: "%.2f", product.price))")
									}
									.padding(.top, 3)
									.padding(.bottom, 3)
									
									Text("Totale €\((String(format: "%.2f", archived_order.getTotal())))")
									
									Section{
										Button {
											order.buildNewOrderFromOldOrder(order: archived_order)
										} label: {
											Text("Effettua stesso ordine")
												.padding()
												.foregroundColor(.white)
												.background(.blue)
												.cornerRadius(8)
										}
										.frame(maxWidth: .infinity, alignment: .center)
										.listRowBackground(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
										.padding()
									}
								}
							}
						}
					}
				}
				.alert("Attenzione! Ordine non modificato", isPresented: $order.showingAlertOtherBusiness) {
					Button("OK") { }
				} message: {
					Text(order.alertOtherBusinessMessage)
				}
				
				.alert("Prodotti aggiunti all'ordine", isPresented: $order.showingAlertModifiedOrder) {
					Button("OK") { }
				} message: {
					Text(order.alertModifiedOrderMessage)
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
