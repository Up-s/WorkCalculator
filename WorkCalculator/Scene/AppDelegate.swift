//
//  AppDelegate.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import Firebase
import UPsKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - DeviceUUID
        
        if UserDefaultsManager.deviceUUID == nil {
            UserDefaultsManager.deviceUUID = UUID().uuidString
        }
        
        
        
        // MARK: - Firebase
        
        FirebaseApp.configure()
        
        
        
        // MARK: - Scene
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .systemGray
        self.window?.makeKeyAndVisible()
        
        let coordinator = SceneCoordinator(window: self.window!)
        SceneCoordinator.shared = coordinator
        coordinator.transition(scene: Scene.splash, style: .root, animated: false)
        
        return true
    }
}

