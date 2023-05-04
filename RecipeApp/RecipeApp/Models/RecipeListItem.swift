//
//  RecipeEntry.swift
//  RecipeApp
//
//  Created by Nathan Wale on 28/3/2023.
//

import Foundation

// recipe ids are strings
typealias RecipeIdentifier = String


//
// Item for recipe lists
//  - name: name of recipe
//  - imageUrl: URL of image
//  - identifier: id of recipe in database
//
struct RecipeListItem
{
    let name: String
    let imageUrl: URL
    let identifier: RecipeIdentifier
    var newlyAdded = false
}


//
// Codable implementation
//
extension RecipeListItem: Codable
{
    // JSON keys for values
    enum CodingKeys: String, CodingKey
    {
        case name = "strMeal"
        case imageUrl = "strMealThumb"
        case identifier = "idMeal"
    }
}


//
// Hashable implementation
//
extension RecipeListItem: Hashable
{
    // hash function, use recipe name
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(name)
    }
    
    // equals, use identifier
    static func ==(a: RecipeListItem, b: RecipeListItem) -> Bool
    {
        a.identifier == b.identifier
    }
}
