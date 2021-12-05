//
//  LocaliView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

struct LocaliView: View {
    @State var results = [Product]()
    var body: some View {
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                Text(item.name!)
                    .font(.headline)
            }
        }.onAppear(perform: loadData)
    }

    func loadData() {
        print ("\n-----------HTTP REQUEST ---------\(base_server_uri + "drink")")
        print("sono qui")
        guard let url = URL(string: base_server_uri + "drink") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("aaaaa")
        print(request)
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                // self.results = responseJSON
                print(responseJSON)
                print(responseJSON.keys)
                let mirror = Mirror(reflecting: Product())
                let list_prod = mirror.children.compactMap { $0.label }
                
                if responseJSON.keys.allSatisfy({ list_prod.contains($0)}){
                    print("E' un oggetto Product")
                    let prod = Product(id: responseJSON["id"] as! String, name: responseJSON["name"] as! String, ingredients: responseJSON["ingredients"] as! Array<String>, image: responseJSON["image"] as! String, category: responseJSON["category"] as! String, stamps: responseJSON["stamps"] as! Array<String>)
                    var list = Array<Product>()
                    list.append(prod)
                    self.results = list
                }
            }
        }

        task.resume()
    }
}


struct LocaliView_Previews: PreviewProvider {
    static var previews: some View {
        LocaliView()
    }
}


