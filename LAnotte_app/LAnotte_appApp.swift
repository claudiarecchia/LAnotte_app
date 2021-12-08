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
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(order)
        }
    }
}
