//
//  RecipeSearchRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 4/4/2023.
//

import Foundation


// search.php?s=Chicken

struct RecipeSearchRequest: ApiRequest
{
    typealias Response = [String: [RecipeListItem]?]
    
    var searchTerm: String
    
    var subPath: String {
        "search.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "s", value: searchTerm)]
    }
    
    //
    // Fetch search results
    // - return type [RecipeDetail]
    // - returns [] if no results
    //
    func fetchSearchResults() async throws -> [RecipeListItem]
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
