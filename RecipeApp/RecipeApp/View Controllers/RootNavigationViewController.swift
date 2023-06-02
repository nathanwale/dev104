//
//  ViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 27/3/2023.
//

import UIKit

//
// Root Navigation.
// ...is a tab bar controller
// ...all View Controllers are a child of this one
//
class RootNavigationViewController: UITabBarController
{
    // attached view controllers
    var savedRecipesViewController: FavouriteRecipesViewController!
    
    // list of recipe list controllers
    var recipeListControllers = [RecipeListTableViewController]()
   
    // MARK: - initialisation
    //
    // View did load:
    // ..assign save delegate to child VCs
    // ..assign saved recipes controller
    //
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // assign save delegate
        assignSaveDelegateToChildren()

        // assign saved recipes controller
        assignSavedRecipesController()
    }
    
    
    //
    // View did appear:
    // ..update navigation colour
    //
    override func viewDidAppear(_ animated: Bool)
    {
        updateNavigationColour(for: selectedIndex)
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
    
    
    //
    // Did select tab item
    // ..update navigation colour
    //
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        if let index = tabBar.items?.firstIndex(of: item) {
            updateNavigationColour(for: index)
        }
        
    }
    
    
    //
    // Set navigation colour based on index
    //
    func updateNavigationColour(for index: Int)
    {
        let colours: [UIColor] = [
            .systemBlue,
            .systemPink,
            .systemPurple,
            .systemGreen,
        ]
        
        if let window = view.window {
            window.tintColor = colours[index]
        }
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
        
        // update count on saved tab badge
        updateSavedBadge()
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
        
        // update count on saved tab badge
        updateSavedBadge()
    }
    
    
    //
    // update count on saved tab badge
    //
    func updateSavedBadge()
    {
        guard let savedTabBarItem = tabBar.items?.first else {
            return
        }
        
        let count = savedRecipesViewController.newlyAddedRecipes.count
        
        if count > 0 {
            savedTabBarItem.badgeValue = String(count)
        } else {
            savedTabBarItem.badgeValue = nil
        }
    }
    
}
