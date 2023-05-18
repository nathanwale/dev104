//
//  RecipeSearchTest.swift
//  RecipeAppTests
//
//  Created by Nathan Wale on 11/4/2023.
//

import XCTest
@testable import RecipeApp

final class RecipeForIngredientTests: XCTestCase {

    func testRecipesForIngredientWithResults() async throws
    {
        let request = RecipesForIngredientRequest(ingredient: "Baking Powder")
        let results = try await request.fetchRecipes()
        
        XCTAssertGreaterThan(results.count, 0, "Search result list is not empty")
        XCTAssertEqual(results[0].name, "Apam balik", "First result is Apam balik")
        XCTAssertEqual(results[1].name, "Banana Pancakes", "Second result is Banana Pancakes")
    }

    func testRecipesForIngredientWithNoResults() async throws
    {
        let request = RecipesForIngredientRequest(ingredient: "FalseIngredient")
        let results = try await request.fetchRecipes()
        
        XCTAssertEqual(results, [], "No search results should mean an empty list")
    }
}
