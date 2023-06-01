//
//  IngredientRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 3/4/2023.
//

import Foundation

// eg.: list.php?i=list

//
// List of ingredients fetched from server
//
struct IngredientListRequest: ApiRequest
{
    typealias Response = [String: [IngredientDecoder]]
    
    // Encoding of JSON response
    struct IngredientDecoder: Codable
    {
        let ingredient: Ingredient
        
        enum CodingKeys: String, CodingKey
        {
            case ingredient = "strIngredient"
        }
    }
    
    var subPath: String {
        "list.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "i", value: "list")]
    }
    
    //
    // Fetch ingredients as list of Ingredient type
    //
    func fetchIngredients() async throws -> [Ingredient]
    {
        // extract Ingredients from IngredientDecoders
        try await send()["meals"]!.map { $0.ingredient }
    }
}
