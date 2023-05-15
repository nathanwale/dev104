//
//  RecipeDetail.swift
//  RecipeApp
//
//  Created by Nathan Wale on 28/3/2023.
//

import Foundation

fileprivate let ingredientFieldRange = 1...20

// MARK: - Model
//
// Model for Recipe detail:
//  - identifier: ID of recipe
//  - name: Name of the recipe
//  - category: Category this recipe is filed under
//  - region: Region (as in nationality) for this recipe
//  - instructions: Instructions for recipe
//  - imageUrl: URL to image of recipe
//  - videoUrl: URL to video tutorial of recipe
//  - tags: list of tags for recipe
//  - ingredients: list of ingredients with measurements
//
struct RecipeDetail
{
    let identifier: RecipeIdentifier
    let name: String
    let category: RecipeCategory
    let region: String
    let instructions: String
    let imageUrl: URL?
    let videoUrl: URL?
    let tags: [String]
    let ingredients: [IngredientMeasurement]
}


// MARK: - Decodable
//
// Decodable implentation for RecipeDetail
//
extension RecipeDetail: Decodable
{
    //
    // Coding keys for one-to-one API keys
    //
    enum CodingKeys: String, CodingKey
    {
        case identifier = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case region = "strArea"
        case instructions = "strInstructions"
        case imageUrl = "strMealThumb"
        case videoUrl = "strYoutube"
        case tagString = "strTags"
    }
    
    //
    // Support for dynamic construction of Coding Keys
    //
    private struct DynamicDecodingKey: CodingKey
    {
        var stringValue: String
        var intValue: Int?
        
        // Init for a string value key
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        // Int value keys are unneeded, but required for the protocol
        // so return nil
        init?(intValue: Int) {
            return nil
        }
    }
    
    // We need to manually decode because of the way
    // ingredients and measurements are keyed as individual values
    // instead of a list.
    init(from decoder: Decoder) throws
    {
        // get unencoded values defined in CodingKeys
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // decode values and assign to properties
        identifier = try values.decode(RecipeIdentifier.self, forKey: .identifier)
        name = try values.decode(String.self, forKey: .name)
        category = try values.decode(RecipeCategory.self, forKey: .category)
        region = try values.decode(String.self, forKey: .region)
        instructions = try values.decode(String.self, forKey: .instructions)
        imageUrl = try? values.decode(URL.self, forKey: .imageUrl)
        videoUrl = try? values.decode(URL.self, forKey: .videoUrl)
        
        // decode tags and split into list of tags
        let tagString = try values.decode(String?.self, forKey: .tagString) ?? ""
        tags = tagString.split(separator: ",").map { String($0) }
        
        // decode ingredients and measurements into list of RecipeIngredient
        let ingredientValues = try decoder.container(keyedBy: DynamicDecodingKey.self)
        ingredients = try ingredientFieldRange.compactMap {
            let ingredient = try ingredientValues.decode(Ingredient?.self, forKey: DynamicDecodingKey(stringValue: "strIngredient\($0)")!)
            let measurement = try ingredientValues.decode(Measurement?.self, forKey: DynamicDecodingKey(stringValue: "strMeasure\($0)")!)
            if let ingredient = ingredient,
               ingredient != "" {
                return IngredientMeasurement(ingredient: ingredient, measurement: measurement ?? "")
            } else {
                return nil
            }
        }
    }
}


// MARK: - Hashable
//
// Hashable implementation
//
extension RecipeDetail: Hashable
{
    // Use identifier for hashing
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    // Use identifier for equality
    static func ==(a: RecipeDetail, b: RecipeDetail) -> Bool
    {
        a.identifier == b.identifier
    }
}
