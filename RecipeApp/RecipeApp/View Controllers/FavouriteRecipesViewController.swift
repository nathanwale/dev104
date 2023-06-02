//
//  FavouriteRecipesViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit

//
// List of saved recipes
// ...subclass of RecipeListTableViewController
// ...marks newly added recipes for highlighting in UI
// ...is notified when recipes are saved or unsaved
//
class FavouriteRecipesViewController: RecipeListTableViewController
{
    // items that have recently been added
    var newlyAddedRecipes = [RecipeListItem]()
    
    
    // MARK: - lifecycle
    
    //
    // view will appear:
    //   - mark newly added recipes
    //
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // mark new recipes
        markNewRecipes()
    }

    
    //
    // view did disappear:
    //   - unmark newly added recipes
    //
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        unmarkNewRecipes()
    }
    
    
    // MARK: - navigation
    override func navigationForView() -> AppNavigation
    {
        .savedRecipes(.all)
    }
    
    override func navigationForSelectedRecipe(identifier: RecipeIdentifier) -> AppNavigation
    {
        .savedRecipes(.recipe(identifier))
    }
    
    
    // MARK: - style
    //
    // mark new items
    //
    func markNewRecipes()
    {
        for i in newlyAddedRecipes.indices {
            newlyAddedRecipes[i].newlyAdded = true
        }

        updateItems(newlyAddedRecipes)
    }
    
    
    //
    // unmark new items, empty newly added recipes, remove badge from tab bar
    //
    func unmarkNewRecipes()
    {
        for i in newlyAddedRecipes.indices {
            newlyAddedRecipes[i].newlyAdded = false
        }

        updateItems(newlyAddedRecipes)
        newlyAddedRecipes = []
        
        if let tabBarItem = tabBarController?.tabBar.items?.first {
            tabBarItem.badgeValue = nil
        }
    }
    
    
    // MARK: - datasource
    //
    // Load saved recipes from UserStore
    //
    override func loadItems()
    {
        replaceItems(items: UserRecipeStore.shared.savedRecipes)
    }
    
    
    //
    // recipe was saved, add to snapshot
    //
    func recipeWasSaved(_ recipe: RecipeListItem)
    {
        addItem(recipe)
        newlyAddedRecipes.append(recipe)
    }
    
    
    //
    // recipe was unsaved, remove from snapshot
    //
    func recipeWasUnsaved(_ recipe: RecipeListItem)
    {
        removeItem(recipe)
        newlyAddedRecipes.removeAll { $0 == recipe }
    }
}
