//
//  FavouriteRecipesViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit

//
// List of Ingredients fetched from Remote API
// ...Section 0 is the actual Ingredient list
// ...Section 1 is used to show a loading indicator
// ...Requires SaveRecipeDelegate
//
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
    
    // are we loading?
    var isLoading = true
    
    
    // MARK: - lifecycle
    override func viewDidLoad()
    {
        // show loading message
        isLoading = true
        tableView.reloadData()
        
        // fetch ingredients
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
            
            // hide loading message
            isLoading = false
            
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
        // grab ingredient cell or loading message cell
        // depending on section
        if indexPath.section == 0 {
            // ingredient cell
            return ingredientCell(indexPath: indexPath)
        } else {
            // loading message cell
            return loadingIndicatorCell()
        }
    }
    
    
    //
    // Configure and return ingredient cell
    //
    func ingredientCell(indexPath: IndexPath) -> UITableViewCell
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // section 0 is the ingredients,
        // section 1 is actually the loading animation
        if section == 0 {
            // ingredients
            return ingredients.count
        } else {
            // loading animation
            if isLoading {
                // show if loading
                return 1
            } else {
                // hide if not loading
                return 0
            }
        }
    }
    
    //
    // Number of sections:
    //      the second section is used for a loading message
    //
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if isLoading {
            return 2
        } else {
            return 1
        }
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
    
    
    // MARK: - loading indicator
    //
    // Return and animate loading indicator cell
    //
    func loadingIndicatorCell() -> UITableViewCell
    {
        // get cell
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty")
        else {
            fatalError("No cells with reuse id 'Empty'")
        }
        
        // loading animation
        animateLoadingCell(cell: cell)
        
        return cell
    }
    
    
    //
    // Animate loading indicator cell
    //  - spins the embedded image in the cell
    //
    func animateLoadingCell(cell: UITableViewCell)
    {
        // grab image inside cell
        let image = cell.contentView.subviews.first!
        
        // start spinning!
        UIView.animate(
            withDuration: 5.0,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.1,
            options: [.repeat, .autoreverse])
        {
            image.transform = image.transform.rotated(by: .pi * 1)
        }
    }
}



