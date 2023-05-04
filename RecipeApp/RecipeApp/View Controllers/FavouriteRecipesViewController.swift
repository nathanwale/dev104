//
//  FavouriteRecipesViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit

class FavouriteRecipesViewController: RecipeListTableViewController
{
    //
    // Load saved recipes from UserStore
    //
    override func loadItems()
    {
        replaceItems(items: UserStore.savedRecipes)
    }
    
    //
    // recipe was saved, add to snapshot
    //
    func recipeWasSaved(_ recipe: RecipeListItem)
    {
        addItem(recipe)
    }
    
    //
    // recipe was unsaved, remove from snapshot
    //
    func recipeWasUnsaved(_ recipe: RecipeListItem)
    {
        removeItem(recipe)
    }
}
