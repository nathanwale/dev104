//
//  NSUserActivity.swift
//  RecipeApp
//
//  Created by Nathan Wale on 25/5/2023.
//

import Foundation

/**
Extend `NSUserActivity` to save navigation key
*/
extension NSUserActivity
{
    // activity type
    static var activityType: String { "com.nathanwale.recipeapp.restoration"}
    
    // key to use for dictionary restoration
    var navigationKey: String { "appNavigation" }
    
    // navigation state of the app
    var navigation: AppNavigation
    {
        // decode from userInfo
        get {
            guard let jsonData = userInfo?[self.navigationKey] as? Data,
                  let nav = try? JSONDecoder().decode(AppNavigation.self, from: jsonData)
            else
            {
                // default state if we can't decode
                return AppNavigation.defaultState()
            }
            
            return nav
        }
        
        // encode into userInfo
        set {
            // can newValue be encoded as JSON?
            if let jsonData = try? JSONEncoder().encode(newValue) {
                // ...yes: store new value
                userInfo?[navigationKey] = jsonData
            } else {
                // ...no: store default navigation
                userInfo?[navigationKey] = AppNavigation.defaultState()
            }
        }
    }
}
