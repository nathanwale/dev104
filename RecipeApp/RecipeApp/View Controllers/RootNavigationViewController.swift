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
    
    // list of recipe list controllers
    var recipeListControllers = [RecipeListTableViewController]()
   
    // MARK: - initialisation
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // assign save delegate
        assignSaveDelegateToChildren()

        // assign saved recipes controller
        assignSavedRecipesController()
    }
    
    
    //
    // assign save delegate to child controllers that require it
    //
    func assignSaveDelegateToChildren()
    {
        let requiresSaveDelegateControllers = viewControllers!.compactMap {
            $0.children.first as? RequiresSaveRecipeDelegate
        }
        
        for var vc in requiresSaveDelegateControllers {
            vc.saveRecipeDelegate = self
            if let vc = vc as? RecipeListTableViewController {
                registerRecipeListController(vc)
            }
        }
    }
    
    
    //
    // assign saved recipes controller
    //
    func assignSavedRecipesController()
    {
        // find first FavouriteRecipesViewController
        let vc = viewControllers!.compactMap {
            $0.children.first as? FavouriteRecipesViewController
        }.first!
        
        // assign it
        savedRecipesViewController = vc
    }
}


// MARK: - SaveRecipeDelegate conformance
extension RootNavigationViewController: SaveRecipeDelegate
{
    //
    // Add controller to recipe list controllers
    //
    func registerRecipeListController(_ controller: RecipeListTableViewController)
    {
        recipeListControllers.append(controller)
    }
    
    
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
        
        // tell all registered recipe list VCs
        for listController in recipeListControllers {
            listController.updateSaveState(recipe: recipe, saved: true)
        }
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
        
        // tell all registered recipe list VCs
        for listController in recipeListControllers {
            listController.updateSaveState(recipe: recipe, saved: false)
        }
    }
    
}
