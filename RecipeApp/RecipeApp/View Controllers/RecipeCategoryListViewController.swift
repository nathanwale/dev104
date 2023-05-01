//
//  FavouriteRecipesViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit


class RecipeCategoryListViewController: UITableViewController
{
    let reuseIdentifier = "RecipeCategory"
    
    // MARK: - items
    //
    // Configure cell with category text
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        // get content config
        var content = cell.defaultContentConfiguration()
        
        // get item from categories
        let key = sectionOrder[indexPath.section]
        let item = categories[key]![indexPath.row]
        
        // assign to content text
        content.text = item
        
        // assign content back to cell
        cell.contentConfiguration = content
        
        return cell
    }
    
    //
    // Header for sections
    //
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionOrder[section].rawValue
    }
    
    
    // MARK: - sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        categories.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionOrder[section]
        return categories[key]!.count
    }
}


// MARK: - view model

extension RecipeCategoryListViewController
{
    enum Section: String {
        case diet = "Diet"
        case meal = "Meal"
        case ingredient = "Ingredient"
    }
    
    var sectionOrder: [Section] {
        [.diet, .meal, .ingredient]
    }
    
    var categories: [Section: [RecipeCategory]] {
        [
            .diet: [
                "Vegan",
                "Vegetarian",
            ],
            .ingredient: [
                "Beef",
                "Chicken",
                "Goat",
                "Lamb",
                "Pasta",
                "Pork",
                "Seafood",
            ],
            .meal: [
                "Breakfast",
                "Dessert",
                "Side",
                "Starter",
            ]
        ]
    }
}

