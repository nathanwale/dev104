//
//  AppDelegate.swift
//  RecipeApp
//
//  Created by Nathan Wale on 27/3/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{


    // MARK: - launch options
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let tempDirectory = URL(filePath: NSTemporaryDirectory())
        
        let urlCache = URLCache(
            memoryCapacity: 25_000_000,
            diskCapacity: 50_000_000,
            directory: tempDirectory)
        
        URLCache.shared = urlCache
        
        return true
    }
    

    // MARK: - UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

