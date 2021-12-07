//
//  BusinessDetailView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 07/12/21.
//

import SwiftUI

struct BusinessDetailView: View {
    
    var business: Business
    var star_number: Int = 0
    
    var body: some View {
        VStack{
            ZStack{
                Image("business")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 4)
                VStack(spacing: 6){
                    
                    LAnotteRoundedImageView(image: "business", dimension: 90)
                    
                    Text(business.business_name)
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                    
                    if (business.description != ""){
                        Text(business.description)
                            .foregroundColor(.white)
                            .fontWeight(.light)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .font(.callout)
                            .multilineTextAlignment(.center)
                    }
                    
                    BusinessRatingStarsView(business: business)
                    
                    HStack{
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                        Text("20:00 - 02:00")
                            .foregroundColor(.white)
                            .fontWeight(.light)
                    }
                }
            }
            
            
            
            
            
            Spacer()
            
        }
        .edgesIgnoringSafeArea(.top)
        
        
        
        
    }
}

struct BusinessRatingStarsView : View {
    
    var business: Business
    
    var body: some View{
        HStack{
            ForEach(0..<Int(business.rating)) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
            }
            if (business.rating.truncatingRemainder(dividingBy: 2) != 0){
                Image(systemName: "star.leadinghalf.filled")
                    .foregroundColor(.white)
            }
            if Int(business.rating) + Int(business.rating.truncatingRemainder(dividingBy: 2)) < 5 {
                ForEach(Int(business.rating + business.rating.truncatingRemainder(dividingBy: 2))..<5) { _ in
                    Image(systemName: "star")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailView(business: Business.defaultBusiness)
    }
}
