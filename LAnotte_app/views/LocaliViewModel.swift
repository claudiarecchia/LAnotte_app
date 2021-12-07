//
//  LocaliViewModel.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/12/21.
//

import Foundation

final class LocaliViewModel : ObservableObject {
    
    @Published var businesses: [Business] = []
    
    func loadData(path: String, method: String){
        guard let url = URL(string: base_server_uri + path) else{
            fatalError("URL mancante")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            do {
                let response = try? JSONDecoder().decode([Business].self, from: data)
                DispatchQueue.main.async {
                    self.businesses = response!
                }
                
            }
        }
        
        task.resume()
    }
    
}
