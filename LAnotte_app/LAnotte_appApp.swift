//
//  LAnotte_appApp.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI

@main
struct LAnotte_appApp: App {
    
    @StateObject var order = Order()
	@StateObject var user = User()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(order)
				.environmentObject(user)
        }
    }
}
