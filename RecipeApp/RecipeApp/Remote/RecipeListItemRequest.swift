//
//  RecipeDetailRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 3/4/2023.
//

import Foundation

// lookup.php?i=52772

//
// Request a RecipeListItem object by id
//  - recipeIdentifier: id of the recipe
//  - fetchRecipeListItem(): fetch and return the RecipeDetail object
//
struct RecipeListItemRequest: ApiRequest
{
    typealias Response = [String: [RecipeListItem]?]
    
    var recipeIdentifier: RecipeIdentifier
    
    var subPath: String {
        "lookup.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "i", value: recipeIdentifier)]
    }
    
    //
    // fetch and return the RecipeListItem object
    // is async, throws ApiRequestError.notFound if no recipe is returned
    func fetchRecipeListItem() async throws -> RecipeListItem
    {
        // send() returns a dictionary with one key ["meals"]
        let result = try await send()
        
        // if the key doesn't exist, throw error
        // this is an unusual case
        guard let recipes = result["meals"] else {
            throw ApiRequestError.requestFailed
        }
        
        // if the key exists, return the RecipeListItem,
        // else throw .notFound 
        if let recipes = recipes {
            return recipes[0]
        } else {
            throw ApiRequestError.notFound
        }
    }
}
