//
//  AppDelegate.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 28/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import UserNotifications
import MBProgressHUD
import NYAlertViewController
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{
    var window: UIWindow?
    var navigationController : UINavigationController?
    
    class func sharedInstance() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let prefs = UserDefaults.standard
//        
//        prefs.set("5", forKey: "user_id")
//        prefs.set("LLEHFDRTSQPKQTF4WHXPWVXMWGRJH8", forKey: "access_token")
//        prefs.set("1", forKey: "is_already_registered")
//        prefs.set("1", forKey: "user_is_verified")
//        prefs.set("1", forKey: "autologin")
//        prefs.synchronize()
        // Override point for customization after application launch.
        
        //GOOGLE MAP
        GMSServices.provideAPIKey("AIzaSyATemLSEtxiuFpUcoeobD70OVP32pHuFzY")
        GMSPlacesClient.provideAPIKey("AIzaSyATemLSEtxiuFpUcoeobD70OVP32pHuFzY")


        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = false
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        //        let uuid = UUID().uuidString
        
        print("UUID: \(uuid)")
        UserDefaults.standard.set(uuid, forKey: "device_id")
        UserDefaults.standard.synchronize()
        
        registerForPushNotifications()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        
        let viewController: User_SplashViewController = User_SplashViewController()
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.window?.endEditing(true)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "applicationDidEnterBackgroundEvent"), object: self)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "applicationWillEnterForegroundEvent"), object: self)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Notification Methods
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    func registerForPushNotifications()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            UNUserNotificationCenter.current().delegate = self
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        UserDefaults.standard.set(token, forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register: \(error)")
        
        UserDefaults.standard.set("", forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        //        let aps = userInfo["aps"] as! [String: AnyObject]
        
        completionHandler()
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        
        let alert = aps["alert"]! as! NSDictionary
        let body = alert["body"] as! String
        let title = alert["title"] as! String
        
        let state: UIApplication.State = UIApplication.shared.applicationState
        
        if state == .active
        {
            // foreground
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = "Notification"
            alertViewController.message = body
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = true
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
            
            alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
            alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
            alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
            alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
            
            alertViewController.buttonColor = MySingleton.sharedManager().themeGlobalOrangeColor
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    self.window?.rootViewController?.dismiss(animated: true, completion: nil)
            })
            
            alertViewController.addAction(okAction)
            
            self.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
        }
        else
        {
            //Do stuff that you would do if the application was not active
        }
        
        completionHandler(.newData)
    }
    
    // MARK: - Other Methods
    
    func showAlertViewWithTitle(title: String, detail: String)
    {
        let app = UIApplication.shared.delegate as? AppDelegate
        let window = app?.window
        
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = title
        alertViewController.message = detail
        
        // Customize appearance as desired
        alertViewController.view.tintColor = UIColor.white
        alertViewController.backgroundTapDismissalGestureEnabled = true
        alertViewController.swipeDismissalGestureEnabled = true
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
        
        alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
        alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
        alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
        alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
        
        alertViewController.buttonColor = MySingleton.sharedManager().alertViewLeftButtonBackgroundColor
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Ok",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                //                AppDelegate.sharedInstance().window?.topMostController()?.dismiss(animated: true, completion: nil)
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
        
        alertViewController.addAction(okAction)
        
        self.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
        
        //        DispatchQueue.main.async {
        //            AppDelegate.sharedInstance().window?.topMostController()?.present(alertViewController, animated: true, completion: nil)
        //        }
    }
    
    func showGlobalProgressHUDWithTitle(title: String)
    {
        DispatchQueue.main.async(execute: {
            
            let app = UIApplication.shared.delegate as? AppDelegate
            let window = app?.window
            
            MBProgressHUD.hide(for: window!, animated: true)
            
            let hud = MBProgressHUD.showAdded(to: window!, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = title
            hud.dimBackground = true
        })
    }
    
    func dismissGlobalHUD()
    {
        let app = UIApplication.shared.delegate as? AppDelegate
        let window = app?.window
        
        DispatchQueue.main.async(execute: {
            
            MBProgressHUD.hide(for: window!, animated: true)
        })
    }


}

