//
//  FavouriteRecipesViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit

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
    // unmark new items, empty newly added recipes
    //
    func unmarkNewRecipes()
    {
        for i in newlyAddedRecipes.indices {
            newlyAddedRecipes[i].newlyAdded = false
        }

        updateItems(newlyAddedRecipes)
        newlyAddedRecipes = []
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
