//
//  LocaliView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct LocaliView: View {
	
	@StateObject private var localiViewModel = LocaliViewModel()
	@State private var searchString = ""
	
	var body: some View {
		ZStack{
			if localiViewModel.isLoading{ ProgressView() }
			else{
				VStack{
					LAnotteSearchBar(text: $searchString, placeholderText: "Cerca il nome di un locale")
					List(searchString == "" ? localiViewModel.businesses: localiViewModel.businesses.filter { $0.business_name.containsIgnoringCase(searchString)}, id: \.self) { item in
						
						NavigationLink(destination: BusinessDetailView(business: item), label: {
							VStack(alignment: .leading) {
								HStack{
									LAnotteRoundedImageView(image: "business", dimension: 70)
									Text(item.business_name)
										.font(.headline)
								}
							}
						})
					}
				}
			}
		} .hiddenNavigationBarStyle()
			.onAppear {
				localiViewModel.loadData(path: "allBusinesses", method: "GET")
				UITableView.appearance().contentInset.top = -25
			}
	}
}



struct LocaliView_Previews: PreviewProvider {
	static var previews: some View {
		LocaliView()
	}
}




