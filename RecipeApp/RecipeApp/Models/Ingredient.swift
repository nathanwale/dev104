//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Nathan Wale on 28/3/2023.
//

import Foundation

// Ingredient is a String
typealias Ingredient = String

// Measurement is a String
typealias Measurement = String


//
// Pairing of ingredient and measurement
//   ...used in list of ingredients in recipes
//
struct IngredientMeasurement
{
    let ingredient: Ingredient
    let measurement: Measurement
}


//
// Hashable implementation
//
extension IngredientMeasurement: Hashable
{
    func hash(into hasher: inout Hasher) {
        hasher.combine(ingredient)
        hasher.combine(measurement)
    }
}
