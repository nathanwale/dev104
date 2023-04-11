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
    typealias Response = [String: [IngredientCodable]]
    
    struct IngredientCodable: Codable
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
    
    func fetchIngredients() async throws -> [Ingredient]
    {
        try await send()["meals"]!.map { $0.ingredient }
    }
}
