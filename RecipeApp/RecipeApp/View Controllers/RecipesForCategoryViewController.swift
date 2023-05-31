//
//  RecipesForCategoryViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 15/5/2023.
//

import UIKit

class RecipesForCategoryViewController: RecipeListTableViewController
{
    // MARK: - properties
    let category: RecipeCategory
    var fetchTask: Task<Void, Never>? = nil
    
    
    // MARK: - lifecycle
    //
    // Initialise with coder and recipe category
    //
    init?(coder: NSCoder, category: RecipeCategory, saveDelegate: SaveRecipeDelegate)
    {
        self.category = category
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // update nav controller title
        navigationItem.title = "\(category) recipes"
    }
    
    override func loadItems()
    {
        fetch()
    }
    
    
    // MARK: - navigation
    override func navigationForView() -> AppNavigation {
        .categories(.category(category))
    }
    
    
    override func navigationForSelectedRecipe(identifier: RecipeIdentifier) -> AppNavigation {
        .categories(.recipe(category, identifier))
    }
    
    
    // MARK: - remote
    //
    // Fetch recipes for category
    //
    func fetch()
    {
        // create search request
        let request = RecipesForCategoryRequest(category: category)
        
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
