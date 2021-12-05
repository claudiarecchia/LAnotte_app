//
//  Connection.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation


    
func get_data_from_url(url_f: URLRequest) {
    print ("\n-----------HTTP REQUEST ---------\(url_f)")
    //       print (url_f.httpBody)
    _ =  URLSession.shared.dataTask(with: url_f) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print("error ")
            print(error)
            return
        }
        guard let response = response else {
            return
        }
        guard let data = data else {
            return
        }
        print (data)
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
            
            guard json is [String: Any] else {
                return
            }
            print (response)
        }
        catch let parseError {
            print("JSON Error \(parseError.localizedDescription)")
        }
    }
    
}

