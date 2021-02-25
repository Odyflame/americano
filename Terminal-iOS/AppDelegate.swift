//
//  AppDelegate.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/08/31.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper
import SwiftyJSON
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var goView: MyStudyDetailView?
    var pushEvent: AlarmType?
    var studyID: String = ""
    var studyTitle: String = ""
    var alertID: Int?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 임시 슈가 코드
        print(KeychainWrapper.standard.string(forKey: "refreshToken"))
        print(KeychainWrapper.standard.string(forKey: "accessToken"))
        
        // firebase 연동
        FirebaseApp.configure()
        
        // Noti Request
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            if let studyID = notification["study_id"] as? String,
               let pushEvent = notification["pushEvent"] as? String {
                self.studyID = studyID
                self.pushEvent = AlarmType(rawValue: pushEvent)
            }
        } else {
            window = UIWindow()
            let launchView = LaunchWireFrame.createLaunchModule()
            window?.rootViewController = launchView
            window?.makeKeyAndVisible()
        }
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let studyID = userInfo["study_id"] as? String {
            self.studyID = studyID
        }
        if let pushEvent = userInfo["pushEvent"] as? String {
            self.pushEvent = AlarmType(rawValue: pushEvent)
        }
        if let alertID = userInfo["alert_id"] as? Int {
            self.alertID = alertID
        }
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        sleep(1)
        let event = self.pushEvent
        let studyID = Int(self.studyID)!
        
        guard let view = MyStudyDetailWireFrame.createMyStudyDetailModule(studyID: studyID, studyTitle: "") as? MyStudyDetailView else { return }
        
        switch event {
        case .chat:
            break
        case .studyDelete:
            break
        case .studyUpdate, .studyHostDelegate:
            view.viewState = .StudyDetail
        case .newApply:
            view.applyState = true
            goView = view
        case .newNotice, .updatedNotice:
            view.viewState = .Notice
            goView = view
        case .applyAllowed:
            break
        case .applyRejected:
            break
        case .testPush:
            break
        case .none, .undefined: break
        }
//        이부분에서 런치뷰가 이미 깔려있기에 캐스팅이 되질 않고 특정뷰로 가지않음
//        그렇다고 버전체크와 리프레시토큰을 확인 안할 수 없으므로 그걸 런치뷰에서 다할 것이냐 아니면 앱델리게이트에서 할 것이냐 정하면 되는데
//        뭐가 좀 더 합리적인지 체크해보자
        
        //이건 처음 들어왔을 때 만
        window = UIWindow()
        //여기에 스터디 아이디랑 알림 스타일 넘겨줘야됨
        let launchView = LaunchWireFrame.createLaunchModule(studyID: studyID, pushEvent: pushEvent)
        window?.rootViewController = launchView
        window?.makeKeyAndVisible()
        
        //이건 foreground 일 때
//        if let tabVC = self.window?.rootViewController as? UITabBarController,
//           let navVC = tabVC.selectedViewController as? UINavigationController {
//            navVC.pushViewController(goView!, animated: true)
//        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        KeychainWrapper.standard.remove(forKey: "pushToken")
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        let pushToken = KeychainWrapper.standard.set(deviceTokenString, forKey: "pushToken")
        print("pushToken 성공여부:", pushToken)
        print("pushToken:", KeychainWrapper.standard.string(forKey: "pushToken")!)
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TerminalCoreData")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
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
