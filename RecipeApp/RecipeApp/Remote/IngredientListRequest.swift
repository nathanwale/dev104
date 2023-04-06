//
//  IngredientRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 3/4/2023.
//

import Foundation

// list.php?i=list

struct IngredientListRequest: ApiRequest
{
    typealias Response = [Ingredient]
    
    var subPath: String {
        "list.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "i", value: "list")]
    }
}
