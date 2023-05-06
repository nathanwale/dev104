//
//  SavedRecipesUserStore.swift
//  RecipeApp
//
//  Created by Nathan Wale on 5/5/2023.
//

import Foundation

//
// Storage for saved recipes
//
struct UserRecipeStore
{
    // shared instance
    static var shared = UserRecipeStore()
    
    // saved recipes
    var savedRecipes = [RecipeListItem]()
    
    
    //
    // Private init: loads savedRecipes
    //   * catches and prints errors
    //
    private init()
    {
        do {
            savedRecipes = try loadFromFile()
        } catch {
            print(error)
        }
    }
    
    
    //
    // Save recipe
    //   * catches and prints errors
    //
    mutating func save(recipe: RecipeListItem)
    {
        do {
            savedRecipes.append(recipe)
            try saveToFile(store: savedRecipes)
        } catch {
            print(error)
        }
    }
    
    
    //
    // Unsave recipe
    //   * catches and prints errors
    //
    mutating func unsave(recipe: RecipeListItem)
    {
        do {
            savedRecipes.removeAll {
                $0 == recipe
            }
            try saveToFile(store: savedRecipes)
        } catch {
            print(error)
        }
    }
}


//
// LocalStore conformance
//   - allows loading from and saving to local files
//
extension UserRecipeStore: LocalStore
{
    typealias StoreType = [RecipeListItem]
    
    // name of file to save to
    var fileName: String {
        "saved-recipes"
    }
    
    // new representation of store type
    func newStore() -> [RecipeListItem] {
        []
    }
}
