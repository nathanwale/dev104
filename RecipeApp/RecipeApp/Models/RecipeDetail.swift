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
    let imageUrl: URL
    let videoUrl: URL
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
        imageUrl = try values.decode(URL.self, forKey: .imageUrl)
        videoUrl = try values.decode(URL.self, forKey: .videoUrl)
        
        // decode tags and split into list of tags
        let tagString = try values.decode(String.self, forKey: .tagString)
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


/// JSON Example
//meals
    //0
        //idMeal    "52772"
        //strMeal    "Teriyaki Chicken Casserole"
        //strDrinkAlternate    null
        //strCategory    "Chicken"
        //strArea    "Japanese"
        //strInstructions    "Preheat oven to 350° F. Spray a 9x13-inch baking pan with non-stick spray.\r\nCombine soy sauce, ½ cup water, brown sugar, ginger and garlic in a small saucepan and cover. Bring to a boil over medium heat. Remove lid and cook for one minute once boiling.\r\nMeanwhile, stir together the corn starch and 2 tablespoons of water in a separate dish until smooth. Once sauce is boiling, add mixture to the saucepan and stir to combine. Cook until the sauce starts to thicken then remove from heat.\r\nPlace the chicken breasts in the prepared pan. Pour one cup of the sauce over top of chicken. Place chicken in oven and bake 35 minutes or until cooked through. Remove from oven and shred chicken in the dish using two forks.\r\n*Meanwhile, steam or cook the vegetables according to package directions.\r\nAdd the cooked vegetables and rice to the casserole dish with the chicken. Add most of the remaining sauce, reserving a bit to drizzle over the top when serving. Gently toss everything together in the casserole dish until combined. Return to oven and cook 15 minutes. Remove from oven and let stand 5 minutes before serving. Drizzle each serving with remaining sauce. Enjoy!"
        //strMealThumb    "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"
        //strTags    "Meat,Casserole"
        //strYoutube    "https://www.youtube.com/watch?v=4aZr5hZXP_s"
        //strIngredient1    "soy sauce"
        //strIngredient2    "water"
        //strIngredient3    "brown sugar"
        //strIngredient4    "ground ginger"
        //strIngredient5    "minced garlic"
        //strIngredient6    "cornstarch"
        //strIngredient7    "chicken breasts"
        //strIngredient8    "stir-fry vegetables"
        //strIngredient9    "brown rice"
        //strIngredient10    ""
        //strIngredient11    ""
        //strIngredient12    ""
        //strIngredient13    ""
        //strIngredient14    ""
        //strIngredient15    ""
        //strIngredient16    null
        //strIngredient17    null
        //strIngredient18    null
        //strIngredient19    null
        //strIngredient20    null
        //strMeasure1    "3/4 cup"
        //strMeasure2    "1/2 cup"
        //strMeasure3    "1/4 cup"
        //strMeasure4    "1/2 teaspoon"
        //strMeasure5    "1/2 teaspoon"
        //strMeasure6    "4 Tablespoons"
        //strMeasure7    "2"
        //strMeasure8    "1 (12 oz.)"
        //strMeasure9    "3 cups"
        //strMeasure10    ""
        //strMeasure11    ""
        //strMeasure12    ""
        //strMeasure13    ""
        //strMeasure14    ""
        //strMeasure15    ""
        //strMeasure16    null
        //strMeasure17    null
        //strMeasure18    null
        //strMeasure19    null
        //strMeasure20    null
        //strSource    null
        //strImageSource    null
        //strCreativeCommonsConfirmed    null
        //dateModified    null
