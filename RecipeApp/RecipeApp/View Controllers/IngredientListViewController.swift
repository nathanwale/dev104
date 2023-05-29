//
//  FavouriteRecipesViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit


class IngredientListViewController:
    UITableViewController,
    RequiresSaveRecipeDelegate
{
    // MARK: - properties
    // reuse identifier
    let reuseIdentifier = "IngredientCell"
    
    // save delegate
    var saveRecipeDelegate: SaveRecipeDelegate!
    
    // ingredients to display
    var ingredients = [Ingredient]()
    
    // fetch task
    var fetchTask: Task<Void, Never>? = nil
    
    
    // MARK: - lifecycle
    override func viewDidLoad()
    {
        fetch()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        // update nav
        AppState.shared.navigation = .ingredients(.all)
    }
    
    
    // cancel fetch task on deinit
    deinit
    {
        fetchTask?.cancel()
    }
    
    
    // MARK: - remote
    func fetch()
    {
        // create search request
        let request = IngredientListRequest()
        
        // cancel task if exists
        fetchTask?.cancel()
        
        // create search task
        fetchTask = Task {
            do {
                // fetch results and place in table
                let items = try await request.fetchIngredients()
                load(ingredients: items)
            } catch {
                // on error empty table and print error
                load(ingredients: [])
                print(error)
            }
            
            // finish task
            fetchTask = nil
        }
    }
    
    // MARK: - items
    //
    // Load ingredients into table
    //
    func load(ingredients: [Ingredient])
    {
        self.ingredients = ingredients
        tableView.reloadData()
    }
    
    
    //
    // Configure cell with ingredient text
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        // get content config
        var content = cell.defaultContentConfiguration()
        
        // get item from ingredients
        let item = ingredients[indexPath.row]
        
        // assign to content text
        content.text = item
        
        // assign content back to cell
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    //
    // Number of rows in section
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    
    // MARK: - datasource
    //
    // Ingredient that corresponds to selected row
    //
    func selectedIngredient() -> Ingredient
    {
        let index = tableView.indexPathForSelectedRow!.row
        return ingredients[index]
    }
    
    
    // MARK: - navigation
    //
    // Show recipes segue
    //
    @IBSegueAction func showRecipesForIngredient(_ coder: NSCoder, sender: Any?) -> RecipesForIngredientViewController?
    {
        return RecipesForIngredientViewController(
            coder: coder,
            ingredient: selectedIngredient(),
            saveDelegate: saveRecipeDelegate)
    }
    
    
}



