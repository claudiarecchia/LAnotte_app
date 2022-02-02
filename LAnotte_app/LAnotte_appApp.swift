//
//  LAnotte_appApp.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 05/12/21.
//

import SwiftUI
import UserNotifications
import Firebase
import Foundation


@main
struct LAnotte_appApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
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

class AppDelegate: NSObject, UIApplicationDelegate {
	
	let userDefaults = UserDefaults.standard
	let ordersViewModel = OrdersViewModel()
	
	let gcmMessageIDKey = "gcm.message_id"
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		
		Messaging.messaging().delegate = self
		
		if #available(iOS 10.0, *) {
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self
			
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: {_, _ in })
		} else {
			let settings: UIUserNotificationSettings =
			UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()
		return true
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
					 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		print(userInfo)
		
		
		// UIApplication.shared.applicationIconBadgeNumber = 0
		
		completionHandler(UIBackgroundFetchResult.newData)
	}
}

extension AppDelegate: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		
		let deviceToken:[String: String] = ["token": fcmToken ?? ""]
		print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
		self.userDefaults.set((fcmToken ?? "") as String, forKey: "deviceToken")
		
		// print("READ USER DEFAULTS : " , userDefaults.value(forKey: "deviceToken"))
	}
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
	
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo
		
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		print(userInfo)
		
//		let badgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
//		UIApplication.shared.applicationIconBadgeNumber = badgeNumber
		
		// Change this to your preferred presentation option
		completionHandler([[.banner, .badge, .sound]])
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		
	}
	
	//	func applicationDidBecomeActive(_ application: UIApplication) {
	//		UIApplication.shared.applicationIconBadgeNumber = 0
	//	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID from userNotificationCenter didReceive: \(messageID)")
		}
		
		
		//	  let badgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
		//	  UIApplication.shared.applicationIconBadgeNumber = badgeNumber
		// UIApplication.shared.applicationIconBadgeNumber = 0
		
		//ordersViewModel.getOrdersToCollect()
		
		print(userInfo)
		
		
		completionHandler()
	}
}
