//
//  RecipesForCategoryViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 15/5/2023.
//

import UIKit

class RecipesForIngredientViewController: RecipeListTableViewController
{
    // MARK: - properties
    let ingredient: Ingredient
    var fetchTask: Task<Void, Never>? = nil
    
    
    // MARK: - lifecycle
    //
    // Initialise with coder and ingredient
    //
    init?(
        coder: NSCoder,
        ingredient: Ingredient,
        saveDelegate: SaveRecipeDelegate)
    {
        self.ingredient = ingredient
        super.init(coder: coder)
        self.saveRecipeDelegate = saveDelegate
        saveRecipeDelegate.registerRecipeListController(self)
    }
    
    
    //
    // Required initialiser, not used.
    //
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    
    override func loadItems()
    {
        fetch()
    }
    
    
    // MARK: - navigation
    override func navigationForView() -> AppNavigation
    {
        .ingredients(.ingredient(ingredient))
    }
    
    
    override func navigationForSelectedRecipe(identifier: RecipeIdentifier) -> AppNavigation
    {
        .ingredients(.recipe(ingredient, identifier))
    }
    
    
    // MARK: - remote
    //
    // Fetch recipes for category
    //
    func fetch()
    {
        // create search request
        let request = RecipesForIngredientRequest(ingredient: ingredient)
        
        // cancel task if exists
        fetchTask?.cancel()
        
        // create search task
        fetchTask = Task {
            do {
                // fetch results and place in table
                let items = try await request.fetchRecipes()
                replaceItems(items: items)
            } catch {
                // on error empty table and print error
                replaceItems(items: [])
                print(error)
            }
            
            // update datasource
            updateDataSource()
            
            // finish task
            fetchTask = nil
        }
    }
}
