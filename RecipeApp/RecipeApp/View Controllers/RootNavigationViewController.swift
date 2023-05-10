//
//  ViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 27/3/2023.
//

import UIKit

class RootNavigationViewController: UITabBarController
{
    
    // attached view controllers
    var savedRecipesViewController: FavouriteRecipesViewController!
    var searchedRecipesViewController: SearchRecipeListViewController!
   

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let recipeControllers = viewControllers!.compactMap {
            $0.children.first as? RecipeListTableViewController
        }

        // assign child VCs to properties
        for vc in recipeControllers {
            
            // faves controller
            if let vc = vc as? FavouriteRecipesViewController {
                savedRecipesViewController = vc
                savedRecipesViewController.saveDelegate = self
            }
            
            // search controller
            if let vc = vc as? SearchRecipeListViewController {
                searchedRecipesViewController = vc
                searchedRecipesViewController.saveDelegate = self
            }
        }
    }
}


// MARK: - SaveRecipeDelegate conformance
extension RootNavigationViewController: SaveRecipeDelegate
{
    //
    // save recipe to UserStore
    //
    func save(recipe: RecipeListItem)
    {
        print("Saving", recipe.name)
        // tell user store
        UserRecipeStore.shared.save(recipe: recipe)
        
        // tell saved recipes VC
        savedRecipesViewController.recipeWasSaved(recipe)
        
        // tell searched recipes VC
        searchedRecipesViewController.updateSaveState(recipe: recipe, saved: true)
    }
    
    //
    // remove recipe from UserStore
    //
    func unsave(recipe: RecipeListItem)
    {
        print("Unsaving", recipe.name)
        // tell user store
        UserRecipeStore.shared.unsave(recipe: recipe)
        
        // tell saved recipes VC
        savedRecipesViewController.recipeWasUnsaved(recipe)
        
        // tell searched recipes VC
        searchedRecipesViewController.updateSaveState(recipe: recipe, saved: false)
    }
    
}
