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
    //
    // Launch options
    // ...set up caching
    //
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // get temp dir
        let tempDirectory = URL(filePath: NSTemporaryDirectory())
        
        // configure cache
        let urlCache = URLCache(
            memoryCapacity: 25_000_000,
            diskCapacity: 50_000_000,
            directory: tempDirectory)
        
        // assign cache to shared instance
        URLCache.shared = urlCache
        
        // everything is good
        return true
    }
    

    // MARK: - UISceneSession Lifecycle
    //
    // configuration for Scene Session
    //
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

