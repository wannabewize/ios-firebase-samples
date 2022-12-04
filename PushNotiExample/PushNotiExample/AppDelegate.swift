//
//  AppDelegate.swift
//  PushNotiExample
//
//  Created by Jaehoon Lee on 2022/12/01.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { authorized, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            debugPrint("Noti Authorized :", authorized)
            if authorized {
                // requestAuthorization의 핸들러는 multi thread 에서 동작. 토큰 요청은 메인 쓰레드에서
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                    UNUserNotificationCenter.current().delegate = self
                }
            }
        }
        
        return true
    }
    
    // background notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("application(_:didReceiveRemoteNotification:fetchCompletionHandler)", userInfo["data"])

//        if let vc = UIApplication.shared.windows.first?.rootViewController {
//            let alert = UIAlertController(title: "Wow", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            vc.present(alert, animated: true)
//        }
//        else {
//            debugPrint("Aa")
//        }

        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("didFailToRegisterForRemoteNotificationsWithError", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenStr = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint("didRegisterForRemoteNotificationsWithDeviceToken : ", tokenStr)
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


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint("userNotificationCenter(_:didReceive:withCompletionHandler:)")
        let userInfo = response.notification.request.content.userInfo
        let notiContent = response.notification.request.content
        debugPrint("title : \(notiContent.title), body: \(notiContent.body)")
        
        completionHandler() // let system know, handling notification finished.
        return
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint("userNotificationCenter(_:willPresent:withCompletionHandler:)")
    }
    

}

