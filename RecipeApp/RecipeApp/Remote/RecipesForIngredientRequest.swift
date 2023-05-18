//
//  CategoryListRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 11/4/2023.
//

import Foundation

struct RecipesForIngredientRequest: ApiRequest
{
    typealias Response = [String: [RecipeListItem]?]
    
    var ingredient: Ingredient
        
    var subPath: String {
        "filter.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "i", value: ingredient)]
    }
    
    func fetchRecipes() async throws -> [RecipeListItem]
    {
        // send() returns a dictionary with one key ["meals"]
        let result = try await send()
        
        // if the key doesn't exist, throw error
        // this is an unusual case
        guard let recipes = result["meals"] else {
            throw ApiRequestError.requestFailed
        }
        
        // if the key exists, are there any results?
        if let recipes = recipes {
            // found some results, return them
            return recipes
        } else {
            // no results, return empty array
            return []
        }
    }
}
