//
//  LocaliViewModel.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/12/21.
//

import Foundation

final class LocaliViewModel : ObservableObject {
    
    @Published var businesses: [Business] = []
    @Published var isLoading = true
	
    func loadData(path: String, method: String){
		self.isLoading = true
        guard let url = URL(string: base_server_uri + path) else{
            fatalError("URL mancante")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        // print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
			// print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
            do {
                let response = try? JSONDecoder().decode([Business].self, from: data)
                DispatchQueue.main.async {
					self.isLoading = false
                    self.businesses = response!
                }
            }
        }
        
        task.resume()
    }
	
	func getBusinessObjectFromString(business_name : String) -> Business {
		var result : Business = Business.defaultBusiness
		for business in businesses {
			if business.business_name == business_name {
				result = business
			}
		}
		return result
	}
    
}
