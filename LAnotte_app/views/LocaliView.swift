//
//  LocaliView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct LocaliView: View {
    
    @StateObject private var localiViewModel = LocaliViewModel()
    
    var body: some View {
        NavigationView{
            List(localiViewModel.businesses, id: \.id) { item in
                NavigationLink(destination: BusinessDetailView(business: item), label: {
                    VStack(alignment: .leading) {
                        HStack{
                            LAnotteRoundedImageView(image: "business", dimension: 70)
                            Text(item.business_name)
                                .font(.headline)
                        }
                    }
                })
            }.onAppear {
                localiViewModel.loadData(path: "allBusinesses", method: "GET")
            }
            
            .hiddenNavigationBarStyle()
        }
        
    }
}


struct LocaliView_Previews: PreviewProvider {
    static var previews: some View {
        LocaliView()
    }
}

