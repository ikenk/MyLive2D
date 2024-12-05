//
//  AppDelegate.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/17.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var myViewController: My_ViewControllerBridge = My_ViewControllerBridge.shared()
    var viewController: (UIViewController & MetalViewDelegate)?
    
    var textureManager:My_LAppTextureManager?
    
    var live2DManager:My_LAppLive2DManager?
    
    var sceneIndexTemp:Int?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let defaults = UserDefaults.standard
        let isNotFirstRun = defaults.bool(forKey: NOT_FIRST_RUN)
//        print("[MyLog]isNotFirstRun: \(isNotFirstRun)")
        
        textureManager = .init()
        
        My_AppDelegateBridge.shared().setToAppDelegate(self)
        My_AppDelegateBridge.shared().setToViewController(myViewController)
        My_AppDelegateBridge.shared().setToTextureManager(textureManager)

        let window = UIWindow(frame: UIScreen.main.bounds)
        viewController = ViewController()
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
        
        Live2DCubism.initializeCubism()
        
        My_AppDelegateBridge.shared().viewController.initializeSprite()
        
        live2DManager = My_LAppLive2DManager.shared()
        
        if !isNotFirstRun {
            defaults.set(true, forKey: NOT_FIRST_RUN)
        }
        
        print("[MyLog]application Start")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("[MyLog]applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        textureManager = nil
        
        guard let live2DManager = self.live2DManager else { return }
        sceneIndexTemp = live2DManager.getSceneIndex()
        print("[MyLog]applicationDidEnterBackground")
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        textureManager = .init()
        My_AppDelegateBridge.shared().setToTextureManager(textureManager)
        
        guard let live2DManager = self.live2DManager, let sceneIndexTemp = self.sceneIndexTemp else { return }
        print("[MyLog]sceneIndexTemp: \(sceneIndexTemp)")
        live2DManager.changeScene(sceneIndexTemp)
        print("[MyLog]applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("[MyLog]applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        myViewController.releaseView()
        
        textureManager = nil
        
        Live2DCubism.deinitializeCubism()
        
        self.window = nil
        
        self.viewController = nil
        
        print("[MyLog]applicationWillTerminate")
    }
}

