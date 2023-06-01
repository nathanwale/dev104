//
//  CategoryListRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 11/4/2023.
//

import Foundation

//
// Return list of categories from server
//
struct RecipeCategoryListRequest: ApiRequest
{
    typealias Response = [String: [CategoryDecoder]]
    
    // Encoding of JSON response
    struct CategoryDecoder: Codable
    {
        let category: RecipeCategory
        
        enum CodingKeys: String, CodingKey
        {
            case category = "strCategory"
        }
    }
    
    var subPath: String {
        "list.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "c", value: "list")]
    }
    
    
    //
    // Returns list of RecipeCategories from request
    //
    func fetchCategories() async throws -> [RecipeCategory]
    {
        // Extract RecipeCategories from CategoryDecoders
        try await send()["meals"]!.map { $0.category }
    }
}
