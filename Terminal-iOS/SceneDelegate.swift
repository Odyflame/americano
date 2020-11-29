//
//  SceneDelegate.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/08/31.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let view = ViewController()
//            let view2 = IntroView()
            let view2 = IntroWireFrame.createIntroModule(beginState: .signUp, introState: .emailInput)
            
            /// 리프레쉬 토큰이 없으면 -> 로그인
            if KeychainWrapper.standard.string(forKey: "refreshToken") == nil {
                let view3 = UINavigationController(rootViewController: view2)
                window.rootViewController = view3
            } else {
                if let token = KeychainWrapper.standard.string(forKey: "refreshToken"),
                   let access = KeychainWrapper.standard.string(forKey: "accessToken") {
                    TerminalNetwork.authRequest(refreshToken: token, accessToken: access) { response in
                        
                        if response.result {
                            print("성공띠")
                        } else {
                            print("실패띠")
                        }
                    }
                }
            }
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

