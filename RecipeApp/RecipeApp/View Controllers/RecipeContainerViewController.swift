//
//  ViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 27/3/2023.
//

import UIKit

class RecipeContainerViewController: UIViewController
{
    // outlets
    // segment control
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    // container view that contains the embedded tab bar controller
    @IBOutlet var containerView: UIView!
    
    // embedded tab bar controller
    var embeddedTabBarController: UITabBarController!
    
    // attached view controllers
    var savedRecipesViewController: FavouriteRecipesViewController!
    var searchedRecipesViewController: SearchRecipeListViewController!
    
    enum Segment: String {
        case favourites = "Favourites"
        case search = "Search"
        case categories = "Categories"
        
        static var order: [Self] {
            [.favourites, .search, .categories]
        }
        
        static func forIndex(index: Int) -> Self
        {
            order[index]
        }
        
        var segueIdentifier: String {
            switch self {
                case .favourites:
                    return "showFavourites"
                case .search:
                    return "showSearch"
                case .categories:
                    return "showCategories"
            }
        }
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // assign embedded tabbar controller
        embeddedTabBarController = (children.first as! UITabBarController)
        
        // assign child VCs to properties
        for vc in embeddedTabBarController.viewControllers! {
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
        
        for (i, segment) in Segment.order.enumerated() {
            segmentedControl.setTitle(segment.rawValue, forSegmentAt: i)
        }
    }

    @IBAction func switchEmbeddedView(_ sender: UISegmentedControl)
    {
        // get selected segment and select it
        let i = sender.selectedSegmentIndex
        embeddedTabBarController.selectedIndex = i
    }
    
    
    
}


// MARK: - SaveRecipeDelegate conformance
extension RecipeContainerViewController: SaveRecipeDelegate
{
    //
    // save recipe to UserStore
    //
    func save(recipe: RecipeListItem)
    {
        // tell user store
        UserStore.save(recipe: recipe)
        
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
        // tell user store
        UserStore.unsave(recipe: recipe)
        
        // tell saved recipes VC
        savedRecipesViewController.recipeWasUnsaved(recipe)
        
        // tell searched recipes VC
        searchedRecipesViewController.updateSaveState(recipe: recipe, saved: false)
    }
    
}
