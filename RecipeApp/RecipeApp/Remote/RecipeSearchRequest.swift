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
    typealias Response = [RecipeDetail]
    
    var searchTerm: String
    
    var subPath: String {
        "search.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "s", value: searchTerm)]
    }
}
