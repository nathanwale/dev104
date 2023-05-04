//
//  SaveRecipeDelegate.swift
//  RecipeApp
//
//  Created by Nathan Wale on 3/5/2023.
//

import Foundation

protocol SaveRecipeDelegate
{
    func save(recipe: RecipeListItem)
    func unsave(recipe: RecipeListItem)
}
