//
//  CategoryListRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 11/4/2023.
//

import Foundation

struct RecipeCategoryListRequest: ApiRequest
{
    typealias Response = [String: [CategoryDecoder]]
    
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
    
    func fetchCategories() async throws -> [RecipeCategory]
    {
        try await send()["meals"]!.map { $0.category }
    }
}
