//
//  LAnotteRoundedImageView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 07/12/21.
//

import SwiftUI

struct LAnotteRoundedImageView: View {
    
    var image: String
    var dimension: CGFloat
    
    var body: some View {
        Image(uiImage: UIImage(data: Data(base64Encoded: image)!)!)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: dimension, height: dimension)
            .clipShape(Circle())
            .shadow(color: .gray, radius: 3)
            .padding(.vertical, 7)
    }
}

struct LAnotteRoundedImageView_Previews: PreviewProvider {
    static var previews: some View {
        LAnotteRoundedImageView(image: "business", dimension: 70)
    }
}
