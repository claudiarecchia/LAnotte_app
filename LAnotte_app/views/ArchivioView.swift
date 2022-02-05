//
//  ArchivioView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI
import AuthenticationServices

struct ArchivioView: View {
	
	@StateObject private var ordersViewModel = OrdersViewModel()
	@State private var orders : [Order] = [Order]()
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var order: Order
	@EnvironmentObject var user: User
	
	var body: some View {
		VStack{
			if user.isLoggedIn{
				VStack{
					Text("Archivio ordini")
						.font(.title3)
						.padding(.top, 2)
					
					ZStack{
						if ordersViewModel.isLoading{
							VStack{
								Spacer()
								ProgressView()
								Spacer()
							}
							.frame(maxWidth: .infinity)
							.background(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
						}
						
						else {
							if (ordersViewModel.orders.count) > 0 {
								List(ordersViewModel.orders, id: \.id){ archived_order in
									VStack(alignment: .leading, spacing: 4){
										
										HStack(spacing: 5){
											Text("Stato dell'ordine: ")
												.fontWeight(.semibold)
											switch archived_order.order_status {
												case OrderStatus.placed:
													Text(placed_message)
													.fontWeight(.semibold)
												case OrderStatus.preparing:
													Text(preparing_message)
													.fontWeight(.semibold)
												case OrderStatus.prepared:
													Text(prepared_message)
													.fontWeight(.semibold)
												case OrderStatus.collected:
													Text(collected_message)
													.fontWeight(.semibold)
												default:
													Text("")
												}
										}
										
										HStack{
											if (archived_order.order_status == OrderStatus.prepared){
												Text("Codice per il ritiro nel locale: " + archived_order.code_to_collect)
													.fontWeight(.semibold)
													.foregroundColor(Color.green)
											}
										}
										
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
										
										ForEach(Array(Set(archived_order.products)).sorted()) { product in
											HStack{
												Text("\(archived_order.getQuantityProductInOrder(product: product))x")
												Text(product.name)
												Text("€\(String(format: "%.2f", product.price))")
											}
											.padding(.top, 1)
											.padding(.bottom, 1)
										}
										
										Text("Totale €\((String(format: "%.2f", archived_order.getTotal())))")
											.fontWeight(.medium)
											.padding(.top, 4)
											.padding(.bottom, 4)
										
										Section{
											VStack{
												Text("La mia valutazione per \(archived_order.business.business_name):")
													.multilineTextAlignment(.center)
												
												let keyExists = user.ratings![archived_order.business.business_name] != nil
												if keyExists{
													HStack{
														var business_rating = user.ratings![archived_order.business.business_name]!
														
														ForEach(0..<business_rating, id: \.self) { index in
															Button {
																user.setRating(order: archived_order, rating: index+1)
																Task{
																	await user.saveMyRating(user: user)
																}
															} label: {
																Image(systemName: "star.fill")
																	.foregroundColor(.yellow)
															}
															.buttonStyle(GrowingButton())
														}
														if business_rating < 5 {
															ForEach( business_rating..<5, id: \.self) { index in
																Button {
																	user.setRating(order: archived_order, rating: index+1)
																	Task{
																		await user.saveMyRating(user: user)
																	}
																} label: {
																	Image(systemName: "star")
																		.foregroundColor(.yellow)
																}
																.buttonStyle(GrowingButton())
															}
														}
													}
												}
												else {
													HStack{
														
														ForEach(0..<5, id: \.self) { index in
															Button {
																user.setRating(order: archived_order, rating: index+1)
																Task{
																	await user.saveMyRating(user: user)
																}
															} label: {
																Image(systemName: "star")
																	.foregroundColor(.yellow)
															}
															.buttonStyle(GrowingButton())
														}
													}
												}
											}.frame(maxWidth: .infinity, alignment: .center)
										}
										.padding(.top, 8)
										.padding(.bottom, 8)
										
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
											.buttonStyle(GrowingButton())
										}
									}
								}
								.refreshable{
									Task{
										await ordersViewModel.loadData(path: "archive", method: "POST", user: user)
										ordersViewModel.getOrdersToCollect()
									}
								}.onAppear{
									UIRefreshControl.appearance().tintColor = UIColor.secondarySystemBackground
								}
								
							}
							
							// no orders in archive but user logged
							else{
								VStack{
									Spacer()
									
									Text("Effettua un ordine per vederlo nell'archivio")
										.padding()
										.multilineTextAlignment(.center)
										.foregroundColor(.gray)
										.frame(maxWidth: .infinity)
									Spacer()
								}
								.background(Color(colorScheme == .dark ? .black : .secondarySystemBackground))
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
					
					SignInWithAppleButton(.continue){ request in
						request.requestedScopes = [.email]
					}
				onCompletion: { result in
					switch result {
					case .success(let auth):
						switch auth.credential {
						case let credentials as ASAuthorizationAppleIDCredential:
							let userId = credentials.user
							user.apple_id = userId
							Task {
								await user.AppleLogin(apple_id: userId)
							}
							
						default:
							break
						}
					case .failure(let error): print(error)
					}
				}
				.frame(height: 40)
				.frame(minWidth: 100, maxWidth: 300)
				.cornerRadius(8)
				.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
				}
			}
		}
		.frame(maxWidth: .infinity)
		.onAppear {
			Task{
				await ordersViewModel.loadData(path: "archive", method: "POST", user: user)
				ordersViewModel.getOrdersToCollect()
			}
		}
	}
}

struct ArchivioView_Previews: PreviewProvider {
	static var previews: some View {
		ArchivioView()
	}
}
