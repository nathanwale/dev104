//
//  FavouriteRecipesViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit

class FavouriteRecipesViewController: RecipeListTableViewController
{
    override func loadItems()
    {
        replaceItems(items: UserStore.savedRecipes)
    }
}
