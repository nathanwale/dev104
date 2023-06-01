//
//  SceneDelegate.swift
//  RecipeApp
//
//  Created by Nathan Wale on 27/3/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?
    var tabBarController: UITabBarController!
    var saveRecipeDelegate: SaveRecipeDelegate!
    var storyboard: UIStoryboard!
    
    let recipeDetailStoryboardIdentifier = "RecipeDetail"

    // MARK: - scene restoration
    //
    // Scene will connect
    //
    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity)
    {
        // Type for stateRestorationActivity described in API is WRONG
        // ...it can be nil, and will crash the app if accessed as non-optional
        // ...so we convert it to optional
        let activity = stateRestorationActivity as NSUserActivity?
        
        if let activity = activity {
            AppState.shared.userActivity = activity
            print(AppState.shared.userActivity.navigation)
        }
        
        // assign tab bar controller
        tabBarController = window?.rootViewController as? UITabBarController
        
        // assign saveRecipeDelegate
        saveRecipeDelegate = (tabBarController as! SaveRecipeDelegate)
        
        // assign storyboard
        storyboard = UIStoryboard(name: "Main", bundle: nil)
         
        // restore views
        restoreViews(navigation: AppState.shared.navigation)
        
    }
    
    //
    // State Restoration Activity
    //
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity?
    {
        return AppState.shared.userActivity
    }
    
    
    // MARK: - navigation
    //
    // Route Navigation
    //
    func restoreViews(navigation: AppNavigation)
    {
        // switch to correct tabbar view
        tabBarController.selectedIndex = navigation.tabBarIndex
        
        // restore views based on navigation
        switch navigation {
            // restore saved recipes
            case .savedRecipes(let nav):
                restoreSavedRecipesView(nav)
                
            // restore search
            case .search(let nav):
                restoreSearchView(nav)
                
            // restore categories
            case .categories(let nav):
                restoreCategoriesView(nav)
                
            // restore ingredients
            case .ingredients(let nav):
                restoreIngredientsView(nav)
        }
    }
    
    
    //
    // Restore saved recipes view, or recipe detail view
    //
    func restoreSavedRecipesView(_ navigation: AppNavigation.SavedRecipes)
    {
        let navigationController = (tabBarController.selectedViewController as! UINavigationController)
        switch navigation {
            case .all:
                break
            case .recipe(let identifier):
                pushRecipeDetailView(navigationController: navigationController, identifier: identifier)
        }
    }
    
    
    //
    // Restore search view, or recipe detail view
    //
    func restoreSearchView(_ navigation: AppNavigation.Search)
    {
        let navigationController = (tabBarController.selectedViewController as! UINavigationController)
        let searchVC = (navigationController.children.first as! SearchRecipeListViewController)
        
        switch navigation {
            case .none:
                break
            case .term(let term):
                searchVC.searchTerm = term
            case .recipe(let term, let recipeIdentifier):
                searchVC.searchTerm = term
                pushRecipeDetailView(navigationController: navigationController, identifier: recipeIdentifier)
        }
    }
    
    
    //
    // Restore Categories view...
    // ...or recipes for selected category
    // ...or recipe detail view
    //
    func restoreCategoriesView(_ navigation: AppNavigation.Categories)
    {
        let navigationController = (tabBarController.selectedViewController as! UINavigationController)
        
        switch navigation {
            // show all categories
            case .all:
                break
            
            // show recipes for this category
            case .category(let category):
                pushRecipesForCategoryView(navigationController: navigationController, selectedCategory: category)
                
            // show recipe detail
            case .recipe(let category, let recipeIdentifier):
                pushRecipesForCategoryView(
                    navigationController: navigationController,
                    selectedCategory: category,
                    recipeIdentifier: recipeIdentifier)
        }
    }
    
    
    //
    // Push Recipes For Category view onto nav controller,
    // if recipeIdentifier, then push recipe detail view also
    //
    func pushRecipesForCategoryView(
        navigationController: UINavigationController,
        selectedCategory: RecipeCategory,
        recipeIdentifier: RecipeIdentifier? = nil)
    {
        // instantiate VC from storyboard
        let recipesForCategoryVC = storyboard.instantiateViewController(
            identifier: AppNavigation.Identifiers.recipesForCategory)
        {
            coder in
            return RecipesForCategoryViewController(
                coder: coder,
                category: selectedCategory,
                saveDelegate: self.saveRecipeDelegate)
        }
        
        // push to nav
        navigationController.pushViewController(recipesForCategoryVC, animated: true)
        
        // if recipeIdentifier, push RecipeDetailView
        if let recipeIdentifier = recipeIdentifier {
            pushRecipeDetailView(navigationController: navigationController, identifier: recipeIdentifier)
        }
    }
    
    
    //
    // Restore Ingredients view...
    // ...or recipes for selected ingredient
    // ...or recipe detail view
    //
    func restoreIngredientsView(_ navigation: AppNavigation.Ingredients)
    {
        let navigationController = tabBarController.selectedViewController as! UINavigationController
        
        
        switch navigation {
            // show all ingredients
            case .all:
                break
                
            // show recipes for ingredient
            case .ingredient(let ingredient):
                pushRecipesForIngredientView(
                    navigationController: navigationController,
                    selectedIngredient: ingredient)
                
            // show specific recipe
            case .recipe(let ingredient, let recipeIdentifier):
                pushRecipesForIngredientView(
                    navigationController: navigationController,
                    selectedIngredient: ingredient,
                    recipeIdentifier: recipeIdentifier)
        }
    }
    
    
    //
    // Push Recipes For Ingredient view onto nav controller,
    // if recipeIdentifier, then push recipe detail view also
    //
    func pushRecipesForIngredientView(
        navigationController: UINavigationController,
        selectedIngredient: Ingredient,
        recipeIdentifier: RecipeIdentifier? = nil)
    {
        // instantiate VC from storyboard
        let recipesForIngredientVC = storyboard.instantiateViewController(
            identifier: AppNavigation.Identifiers.recipesForIngredient)
        {
            coder in
            return RecipesForIngredientViewController(
                coder: coder,
                ingredient: selectedIngredient,
                saveDelegate: self.saveRecipeDelegate)
        }
        
        // push to nav
        navigationController.pushViewController(recipesForIngredientVC, animated: true)
        
        // if recipeIdentifier, push RecipeDetailView
        if let recipeIdentifier = recipeIdentifier {
            pushRecipeDetailView(navigationController: navigationController, identifier: recipeIdentifier)
        }
    }
    
    
    //
    // Push Recipe Detail View onto given view controller
    //
    func pushRecipeDetailView(navigationController: UINavigationController, identifier: RecipeIdentifier)
    {
        // Instantiate recipe detail view controller from storyboard
        let recipeVC = storyboard.instantiateViewController(
            identifier: AppNavigation.Identifiers.recipeDetail)
        {
            coder in
            return RecipeDetailViewController(coder: coder)
        }
        
        // assign recipe ID to view controller
        recipeVC.recipeIdentifier = identifier
        
        // push recipe detail controller onto nav controller
        navigationController.pushViewController(recipeVC, animated: true)
        
    }
}

