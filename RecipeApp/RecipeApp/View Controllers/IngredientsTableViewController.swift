//
//  IngredientsTableViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 12/5/2023.
//

import UIKit

class IngredientsTableViewController: UITableViewController
{
    // MARK: - properties
    let cellReuseIdentifier = "IngredientCell"
    var ingredients = [IngredientMeasurement]()
    
    
    // MARK: - setup
    //
    // View did load
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func loadView() {
        super.loadView()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    //
    // Configure with ingredients
    //
    func configure(with ingredients: [IngredientMeasurement])
    {
        self.ingredients = ingredients
        tableView.reloadData()
    }

    
    // MARK: - datasource
    //
    // Number of rows
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ingredients.count
    }

    
    //
    // cell config
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // get item
        let item = ingredients[indexPath.row]
        
        // deqeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        // config
        var config = cell.defaultContentConfiguration()
        config.text = item.ingredient
        config.secondaryText = item.measurement
        
        // attach config to cell
        cell.contentConfiguration = config
        
        // return cell
        return cell
    }
}
