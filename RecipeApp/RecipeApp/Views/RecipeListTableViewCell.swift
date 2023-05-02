//
//  RecipeListTableViewCell.swift
//  RecipeApp
//
//  Created by Nathan Wale on 1/5/2023.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {
    @IBOutlet var view: RecipeListCell!
    
    func update(with recipeListItem: RecipeListItem)
    {
        view.update(with: recipeListItem)
    }
}
