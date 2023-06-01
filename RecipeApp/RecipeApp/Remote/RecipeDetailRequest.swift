//
//  RecipeDetailRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 3/4/2023.
//

import Foundation

// eg.: lookup.php?i=52772

//
// Request a RecipeDetail object by id
//  - recipeIdentifier: id of the recipe
//  - fetchRecipeDetail(): fetch and return the RecipeDetail object
//
struct RecipeDetailRequest: ApiRequest
{
    // response is ["meals": [optional List of recipes]]
    typealias Response = [String: [RecipeDetail]?]
    
    // recipe id
    var recipeIdentifier: RecipeIdentifier
    
    // URL path end
    var subPath: String {
        "lookup.php"
    }
    
    // query string
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "i", value: recipeIdentifier)]
    }
    
    //
    // fetch and return the RecipeDetail object
    // is async, throws ApiRequestError.notFound if no recipe is returned
    func fetchRecipeDetail() async throws -> RecipeDetail
    {
        // send() returns a dictionary with one key ["meals"]
        let result = try await send()
        
        // if the key doesn't exist, throw error
        // this is an unusual case
        guard let recipes = result["meals"] else {
            throw ApiRequestError.requestFailed
        }
        
        // if the key
        if let recipes = recipes {
            return recipes[0]
        } else {
            throw ApiRequestError.notFound
        }
    }
}
