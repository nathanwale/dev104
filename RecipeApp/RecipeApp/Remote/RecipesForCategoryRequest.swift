//
//  CategoryListRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 11/4/2023.
//

import Foundation

//
// Fetch RecipeListItems for a given Category
//
struct RecipesForCategoryRequest: ApiRequest
{
    typealias Response = [String: [RecipeListItem]?]
        
    // the given category
    var category: RecipeCategory
        
    var subPath: String {
        "filter.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "c", value: category)]
    }
    
    
    //
    // fetch RecipeListItems for given category
    //
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
