//
//  RecipeDetailRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 3/4/2023.
//

import Foundation

// lookup.php?i=52772

struct RecipeDetailRequest: ApiRequest
{
    typealias Response = [String: [RecipeDetail]]
    
    var recipeIdentifier: RecipeIdentifier
    
    var subPath: String {
        "lookup.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "i", value: recipeIdentifier)]
    }
}
