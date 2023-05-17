//
//  SaveRecipeDelegate.swift
//  RecipeApp
//
//  Created by Nathan Wale on 3/5/2023.
//

import Foundation

//
// Delegate for handling saving of recipes
//   - Notifies recipe list controllers that a recipe has been saved
//
protocol SaveRecipeDelegate
{
    // save and unsave
    func save(recipe: RecipeListItem)
    func unsave(recipe: RecipeListItem)
    
    // recipe list controllers
    var recipeListControllers: [RecipeListTableViewController] { get set }
    func registerRecipeListController(_ controller: RecipeListTableViewController)
}


//
// Protocol that guarantees user has a SaveRecipeDelegate
//
protocol RequiresSaveRecipeDelegate
{
    var saveRecipeDelegate: SaveRecipeDelegate! { get set }
}
