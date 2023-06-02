//
//  AppNavigation.swift
//  RecipeApp
//
//  Created by Nathan Wale on 24/5/2023.
//

import Foundation


//
// Representation of the app's navigation
//
enum AppNavigation: Codable
{
    case savedRecipes(SavedRecipes)
    case search(Search)
    case categories(Categories)
    case ingredients(Ingredients)
    
    // Showing saved recipes
    enum SavedRecipes: Codable
    {
        // Showing all recipes
        case all
        // Showing recipe with ID
        case recipe(RecipeIdentifier)
    }
    
    // Showing search tab
    enum Search: Codable
    {
        // No search terms entered
        case none
        // Showing recipes for search term
        case term(String)
        // Showing recipe with search term and ID
        case recipe(String, RecipeIdentifier)
    }
    
    // Showing categories
    enum Categories: Codable
    {
        // Showing all categories
        case all
        // Showing recipes for category
        case category(RecipeCategory)
        // showing recipe with Category and recipe ID
        case recipe(RecipeCategory, RecipeIdentifier)
    }
    
    // Showing ingredients list
    enum Ingredients: Codable
    {
        // Showing all ingredients
        case all
        // Showing recipes for ingredient
        case ingredient(Ingredient)
        // Showing recipe with ingredient and ID
        case recipe(Ingredient, RecipeIdentifier)
    }
    
    
    //
    // Default state: show all saved recipes
    //
    static func defaultState() -> Self
    {
        .savedRecipes(.all)
    }
        
    
    // MARK: - identifiers
    //
    // Storyboard IDs for View Controllers
    //
    struct Identifiers
    {
        static let savedRecipes = "SavedRecipes"
        static let searchRecipes = "SearchRecipes"
        static let categories = "Categories"
        static let ingredients = "Ingredients"
        static let recipesForCategory = "RecipesForCategory"
        static let recipesForIngredient = "RecipesForIngredient"
        static let recipeDetail = "RecipeDetail"
    }
}


//
// Tabbar index
//   - for selecting correct tab bar for an AppNavigation
//   - mapped to root navigation in Main storyboard
//
extension AppNavigation
{
    var tabBarIndex: Int {
        get {
            switch self {
                case .savedRecipes:
                    return 0
                case .search:
                    return 1
                case .categories:
                    return 2
                case .ingredients:
                    return 3
            }
        }
    }
}
