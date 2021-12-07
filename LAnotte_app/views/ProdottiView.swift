//
//  ProdottiView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct ProdottiView: View {
    
    @StateObject private var localiViewModel = LocaliViewModel()
    @State private var number = 0
    
    var body: some View {
        Form{
            ForEach(localiViewModel.businesses) { business in
                List(business.products, id: \.id) { item in
                    
                    VStack(alignment: .leading, spacing: 8){
                        HStack{
                            
                            LAnotteRoundedImageView(image: "mule-mug-rame", dimension: 70)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                
                                ProductCategoryStampsView(item: item)
                                
                                Text(item.category)
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                        }
                        HStack{
                            ProductBusiness(business: business)
                        }
                        HStack{
                            ProductIngredientsView(item: item)
                        }
                        Stepper("Aggiunti all'ordine: \(number)", value: $number, in: 0...100)
                    }
                    
                }
            }
        }.onAppear {
            localiViewModel.loadData(path: "allBusinesses", method: "GET")
            
        }
    }
}

struct ProductCategoryStampsView: View{
    
    var item: Product
    
    var body: some View{
        HStack{
            Text(item.name)
                .fontWeight(.semibold)
            
            Spacer()
            if item.stamps.contains("vegan"){
                Image(systemName: "leaf.fill")
            }
            if item.stamps.contains("gluten free"){
                Image("gluten-free")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 19)
            }
        }
    }
}

struct ProductIngredientsView : View{
    
    var item: Product
    
    var body: some View{
        
        Image(systemName: "list.bullet")
        
        Text(item.ingredients.joined(separator: ", "))
            .lineLimit(3)
            .minimumScaleFactor(0.5)
            .font(.caption)
    }
}

struct ProductBusiness : View{
    
    var business: Business
    
    var body: some View{
        Image(systemName: "checkmark.seal")
        Text(business.business_name)
            .font(.subheadline)
            .fontWeight(.light)
    }
}

struct ProdottiView_Previews: PreviewProvider {
    static var previews: some View {
        ProdottiView()
    }
}
