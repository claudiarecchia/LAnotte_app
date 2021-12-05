//
//  FirstView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct FirstView: View {
    @State var index = 0
    var body: some View {
        VStack{
            HStack(){
                Text("Locali")
                    .foregroundColor(self.index == 0 ? .white : .blue.opacity(0.7))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 35)
                    .background(.blue.opacity(self.index == 0 ? 1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        self.index = 0
                    }
                Spacer(minLength: 0)
                Text("Prodotti")
                    .foregroundColor(self.index == 1 ? .white : .blue.opacity(0.7))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 35)
                    .background(.blue.opacity(self.index == 1 ? 1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        self.index = 1
                    }
            }
            .background(Color.black.opacity(0.06))
            .clipShape(Capsule())
            //.padding(.top, 25)
            .padding(.horizontal)
            Spacer(minLength: 0)
            
            TabView(selection: self.$index){
                LocaliView().tag(0)
                ProdottiView().tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        
        
        
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
