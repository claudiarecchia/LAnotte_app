//
//  User.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import Foundation
import CoreVideo

class User{
    
    var id: Int
    var email: String
    var password: String
    
    init(id: Int, email: String, password: String){
        self.id = id
        self.email = email
        self.password = password
    }
}
