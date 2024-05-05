//
//  AppDelegate.swift
//  Trains
//
//  Created by Ali Ali on 7/4/2024.
//

import Foundation
import UIKit
@preconcurrency  import ActivityKit
import FirebaseCore
@preconcurrency import FirebaseFirestoreInternal
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let settings = Firestore.firestore().settings
        settings.host = "127.0.0.1:8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        let db = Firestore.firestore()
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { _, _ in }
        )
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        Task {
            for await data in Activity<LiveTrainsAttributes>.pushToStartTokenUpdates {
                let token = data.map { String(format: "%02x", $0) }.joined()
                TrainLogger.network.debug("Activity pushToStartToken from stream: \(token)")
                do {
                    let userIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
                    try await db.collection("pushTokens").document(userIdentifier).setData(["pushToStartToken": token], merge: true)
                    TrainLogger.network.debug("pushTokens send to firestore")
                } catch {
                    TrainLogger.network.error("\(error)")
                }
            }
        }
        
        Task {
            for await activity in Activity<LiveTrainsAttributes>.activityUpdates {
                TrainLogger.network.debug("Activity Atrribute Update from stream: \(activity.attributes.debugDescription)")
                TrainLogger.network.debug("Activity Content Update from stream: \(activity.content.description)")
                if ActivityManager.actor.currentActivity?.attributes.startStop == activity.attributes.startStop &&
                            ActivityManager.actor.currentActivity?.attributes.endStop == activity.attributes.endStop {
                    await ActivityManager.actor.updateActivity(state: activity.content.state)
                } else {
                    await ActivityManager.actor.endActivity()
                    try? await ActivityManager.actor.startActivity(attribute: activity.attributes, initialState: activity.content.state)
                }
            }
        }
        
        return true
    }
    
    private func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) async {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        TrainLogger.network.log("Device Token: \(deviceTokenString)")
        TokenManager.shared.token = deviceTokenString
        Task { @MainActor in
            do {
                let userIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
                try await Firestore.firestore().collection("pushTokens").document(userIdentifier).setData(["deviceToken": deviceTokenString], merge: true)
            } catch {
                TrainLogger.network.error("\(error)")
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError
                     error: Error) {
        TrainLogger.network.error("Error Registering token \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            didReceive response: UNNotificationResponse,
                                            withCompletionHandler completionHandler:
                                            @escaping () -> Void) {
        // Get the meeting ID from the original notification.
        TrainLogger.network.log("NOTIFICATION: userNotificationCenter didReceive ")
        completionHandler()
    }
    
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            willPresent notification: UNNotification,
                                            withCompletionHandler completionHandler:
                                            @escaping (UNNotificationPresentationOptions) -> Void) {
        TrainLogger.network.log("NOTIFICATION: userNotificationCenter willPresent")
        completionHandler([.banner, .sound, .banner, .list])
    }
}
