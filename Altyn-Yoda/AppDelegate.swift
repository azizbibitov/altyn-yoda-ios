//
//  AppDelegate.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 25.03.2023.
//

import UIKit
import Localize_Swift
import GoogleMaps
import RxSwift
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

    lazy var disposeBag = DisposeBag()
    var window: UIWindow?

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 1) as Date)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        setupAppLang()
        setupAppTheme()
        GMSServices.provideAPIKey("AIzaSyC6zUN1-8JJMS45vtyWcPbqCY1kq0uXbyo")
        GMSServices.setMetalRendererEnabled(true)
        
        if AccountUserDefaults.shared.isUserLogin() == false {
            //Authentication
            if AccountUserDefaults.shared.isSplashShown() == false {
                AccountUserDefaults.shared.splashShown()
                window?.rootViewController = UINavigationController(rootViewController: OnBoardingVC())
            }else{
                window?.rootViewController = UINavigationController(rootViewController: EnterPhoneNumberVC())
            }
            
        }else{
            
            setupNotification(application: application)
            
            if AccountUserDefaults.shared.getPinCodeApp().count == 4 {
                //Pin Code
                let pinCodeVC = EnterPinCodeVC()
                pinCodeVC.headerTitle = "enter_code".localized()
                pinCodeVC.enterPinCode = true
                window?.rootViewController = UINavigationController(rootViewController: pinCodeVC)
            } else {
                //Main
                window?.rootViewController = UINavigationController(rootViewController: MainVC())
            }
            
            getProfile()
        }
        
  
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        return true
    }
    
    func setupNotification(application: UIApplication){
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: UNAuthorizationOptions([.alert, .badge, .sound])) { _, _ in

        }
        application.registerForRemoteNotifications()
    }
    
    func setupAppTheme(){
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = ThemeUserDefaults.shared.theme.getUserInterfaceStyle()
        }
    }
    
    func setupAppLang(){
        if AccountUserDefaults.shared.getLanguageCode() == "" {
            AccountUserDefaults.shared.saveLanguage(languageCode: "ru")
        }
        
        Localize.setCurrentLanguage(AccountUserDefaults.shared.getLanguageCode())
    }

}

extension AppDelegate: MessagingDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if AccountUserDefaults.shared.isNotificationOff() == false {
            Messaging.messaging().setAPNSToken(deviceToken, type: .prod) //= deviceToken
            Messaging.messaging().apnsToken = deviceToken
        }
       }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "nilX")")
        if fcmToken != nil {
            AccountUserDefaults.shared.saveNotificationToken(token: fcmToken!)
        }
        if AccountUserDefaults.shared.isNotificationOff() == false {
            addFCM(token: fcmToken ?? "")
        }
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter( _ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void ) {
//        let userInfo = notification.request.content.userInfo["aps"] as? NSDictionary
//        let threadId = userInfo?["thread-id"] as? String
//        print("threadId: 2", threadId)
//        print("userInfoX: 2", userInfo as Any)
        
        print("willPresent")
        MainVC.shared.notificationArrived.accept((true))
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter( _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void ) {
//        let userInfo = response.notification.request.content.userInfo["aps"] as? NSDictionary
//        let threadId = userInfo?["thread-id"] as? String
        
        print("didReceive")
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let vc = NotificationsVC()
            rootViewController.pushViewController(vc, animated: true)
            UIApplication.shared.applicationIconBadgeNumber = 0
//        }
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
//        MainVC.shared.notificationArrived.accept((true))
    }
    
}

// MARK: - API Requests
extension AppDelegate {
    func getProfile() {
        AuthRequests.shared.getProfile().subscribe { res in
            if res.data == nil {
                self.logOut()
            }
        } onFailure: { _ in
            print("Failure")
            
        }.disposed(by: disposeBag)
    }
    
    func logOut(){
        let languageCode = AccountUserDefaults.shared.getLanguageCode()
        let themeRaw = ThemeUserDefaults.shared.theme.rawValue
        
        AccountUserDefaults.shared.clearUserDefaults()
        
        Localize.setCurrentLanguage(languageCode)
        ThemeUserDefaults.shared.theme = Theme(rawValue: themeRaw) ?? .light
        AccountUserDefaults.shared.saveLanguage(languageCode: languageCode)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UINavigationController(rootViewController:  EnterPhoneNumberVC())
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        } else {
            print("window = UIApplication.shared.windows.first")
        }
    }
    
    func addFCM(token: String) {
        AuthRequests.shared.addFcmToken(token: token).subscribe { res in
            if res.data != nil {
                
            }else{
                
            }
          
        } onFailure: { _ in
            
        }.disposed(by: disposeBag)
    }
}
