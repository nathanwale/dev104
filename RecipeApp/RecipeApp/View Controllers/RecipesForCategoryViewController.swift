//
//  RecipesForCategoryViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 15/5/2023.
//

import UIKit

//
// List of recipes belonging to a category
// ...is a subclass of RecipeListTableViewController
// ...Section 0 is for recipes
// ...Section 1 is for a message indicating no results
//
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
    
    
    //
    // View did load
    // ...update nav title
    //
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // update nav controller title
        navigationItem.title = "\(category) recipes"
    }
    
    
    //
    // Fetch remote items
    //
    override func loadItems()
    {
        fetch()
    }
    
    
    // MARK: - navigation
    // categories category category
    override func navigationForView() -> AppNavigation {
        .categories(.category(category))
    }
    
    
    // Navigation for user selecting a recipe
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
