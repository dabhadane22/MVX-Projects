//
//  AppDelegate.swift
//  MVX
//
//  Created by Rupali Patil on 12/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn

import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging


//745696743204-gfpjkf32eoqjlajg2fl2i0rfshitkuqp.apps.googleusercontent.com

class OrientationManager {
    static var landscapeSupported: Bool = false
}

var m_cCommanData : CommanDataStore!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    var instanceToken: String?
    var deviceTokenString: String?
    var notificationBadgeCount = Int(0)

   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.window = UIWindow()
        
        Settings.isAutoInitEnabled = true
        ApplicationDelegate.initializeSDK(nil)
    GIDSignIn.sharedInstance()?.clientID = "745696743204-gfpjkf32eoqjlajg2fl2i0rfshitkuqp.apps.googleusercontent.com"
        IQKeyboardManager.shared.enable = true
        m_cCommanData = CommanDataStore()
        
        let userDefaults = UserDefaults.standard
        
       if !userDefaults.bool(forKey: "hasRunBefore")
       {
             // Remove Keychain items here
            m_cCommanData.clearUserCreditials()
             // Update the flag indicator
             userDefaults.set(true, forKey: "hasRunBefore")
             userDefaults.synchronize()
        }
        
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
        notificationBadgeCount = 0
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
     }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MVX")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        self.instanceToken = fcmToken
    }
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.instanceToken = result.token
            }
        }
    }
    
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        
        print("willPresent notification: \(userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        
        if let date = userInfo["gcm.notification.date"] as? String {
            print(date)
          //  open view controller on click of notification
            completionHandler()
        }
        
        print("didReceive response: \(userInfo)")
    }
    
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        print("remoteMessage: ",remoteMessage.appData)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print full message.
        print("message recived")
        
        print("didReceiveRemoteNotification: ",userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
        
}

