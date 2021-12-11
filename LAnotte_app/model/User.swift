//
//  User.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation

class User: Codable, Identifiable {
    
    var id: String?
    var email: String?
    var password: String?
    
    init(id: String, email: String, password: String){
        self.id = id
        self.email = email
        self.password = password
    }
	
	// if user is a guest (not logged)
	init(id: String){
		self.id = id
	}
	
	init(){ }
}
