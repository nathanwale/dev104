//
//  AppState.swift
//  RecipeApp
//
//  Created by Nathan Wale on 23/5/2023.
//

import Foundation

struct AppState
{
    // shared instance
    static var shared = AppState()
    
    // navigation state, defaults to saved recipes
    var navigation: AppNavigation {
        get {
            userActivity.navigation
        }
        set {
            userActivity.navigation = newValue
            print(newValue)
        }
    }
    
    // user activity
    var userActivity = NSUserActivity(activityType: NSUserActivity.activityType)
}
