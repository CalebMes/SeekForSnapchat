//
//  SceneDelegate.swift
//  Scavanger Hunt
//
//  Created by Caleb Mesfien on 7/10/20.
//  Copyright © 2020 Caleb Mesfien. All rights reserved.
//

import UIKit
import SCSDKCoreKit
import SCSDKLoginKit
import FirebaseDatabase



let userDefault = UserDefaults.standard
struct DefualtKey {
    static let removeWelcomeView = "removeWelcomeView2"
    static let savedArt = "savedArt"
    static let savedDepartments = "listOfDepartments"
    static let currentURL = "currentURL"
    static let currentDepartmentList = "currentDepartmentList"
    static let listOfSavedImages = "listOfSavedImages"
    static let currentHour = "currentHour"
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let WindowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: WindowScene.coordinateSpace.bounds)
        window?.windowScene = WindowScene
        window?.makeKeyAndVisible()
        window!.overrideUserInterfaceStyle = .light
        
        
        if userDefault.object(forKey: "externalID") == nil{
            window?.rootViewController = UINavigationController(rootViewController: WelcomeView())
        }
//        userDefault.set("CAESIGqPp5I34aBfkIEWgok5p3L3TdYGGteIXDaaCklYQpwS", forKey: "externalID")
//        userDefault.set("https://sdk.bitmoji.com/render/panel/09da38f4-35c2-4237-b893-368d60103c23-AXU5OE1voTiF5G8H8NIBwt3Bq7ygaw-v1.png?transparent=1&palette=1", forKey: "BitmojiURL")
//        userDefault.set("Caleb Mesfien", forKey: "displayName")
//        userDefault.removeObject(forKey: DefualtKey.removeWelcomeView)
//        userDefault.set(false, forKey: DefualtKey.removeWelcomeView)
        if userDefault.object(forKey: DefualtKey.removeWelcomeView) == nil || userDefault.bool(forKey: DefualtKey.removeWelcomeView) == false {
                    userDefault.set(false, forKey: DefualtKey.removeWelcomeView)
                    window?.rootViewController = UINavigationController(rootViewController: WelcomeView())
                }else{
                window?.rootViewController = UINavigationController(rootViewController: ViewController())
                }
        
    }
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//      guard let url = URLContexts.first?.url else {
//          return
//      }
//
//        SCSDKLoginClient.application( UIApplication.shared, open: url, options: nil)
//       }
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>){
//        print("FGHGFFGHFGHFGHFGHJFGHJKGHJKGHJKJKGHGHJK3")
//
//        if let url = URLContexts.first?.url{
//            print("this worked", url)
////            application(_ app: UIApplication,
////                              open url: URL,
////                              options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
////            SCSDKLoginClient.ap
//            
//            SCSDKLoginClient.application(UIApplication.shared, open: url, options:nil)
//
//        }
//        print("false")
////        return false
//
//    }
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SCSDKLoginClient.application(app, open: url, options: options)
}
    var ref = Database.database().reference()

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
         for urlContext in URLContexts {
            print(urlContext.url)
            print("THIS WORKED")
             let url = urlContext.url
             var options: [UIApplication.OpenURLOptionsKey : Any] = [:]
             options[.openInPlace] = urlContext.options.openInPlace
             options[.sourceApplication] = urlContext.options.sourceApplication
             options[.annotation] = urlContext.options.annotation
             SCSDKLoginClient.application(UIApplication.shared, open: url, options: options)
         }
            
         }
            
    
}

