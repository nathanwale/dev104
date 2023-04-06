//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Nathan Wale on 28/3/2023.
//

import Foundation

typealias Ingredient = String
typealias Measurement = String

struct IngredientMeasurement
{
    let ingredient: Ingredient
    let measurement: Measurement
}

extension IngredientMeasurement: Hashable
{
    func hash(into hasher: inout Hasher) {
        hasher.combine(ingredient)
        hasher.combine(measurement)
    }
}
