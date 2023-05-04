//
//  UserStore.swift
//  RecipeApp
//
//  Created by Nathan Wale on 2/5/2023.
//

import Foundation

fileprivate let demoUrl = URL(string: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2Ff0%2Ff0%2Fec%2Ff0f0ec88688c01b59661240899e57d83--people-eating-intelligent-people.jpg&f=1&nofb=1&ipt=01caad78c899c7f2b5367353fff0021ed344d33e295f59fa32f980617bd5d55d&ipo=images")!

struct UserStore
{
    static var savedRecipes = [
        RecipeListItem(name: "Nutrient Paste", imageUrl: demoUrl, identifier: "1"),
        RecipeListItem(name: "Oyako Don", imageUrl: demoUrl, identifier: "2"),
        RecipeListItem(name: "Lanzhou Lamian", imageUrl: demoUrl, identifier: "3"),
        RecipeListItem(name: "Tortellini", imageUrl: demoUrl, identifier: "4"),
    ]
    
    static func save(recipe: RecipeListItem)
    {
        UserStore.savedRecipes.append(recipe)
        UserStore.displayNeedsUpdating = true
    }
    
    static func unsave(recipe: RecipeListItem) {
        UserStore.savedRecipes.removeAll {
            $0 == recipe
        }
        UserStore.displayNeedsUpdating = true
    }
}
