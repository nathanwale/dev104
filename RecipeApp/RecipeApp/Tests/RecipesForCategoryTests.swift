//
//  RecipeSearchTest.swift
//  RecipeAppTests
//
//  Created by Nathan Wale on 11/4/2023.
//

import XCTest
@testable import RecipeApp

final class RecipeForCategoryTests: XCTestCase {

    func testRecipesForCategoryWithResults() async throws
    {
        let request = RecipesForCategoryRequest(category: "Seafood")
        let results = try await request.fetchRecipes()
        
        XCTAssertGreaterThan(results.count, 0, "Search result list is not empty")
        XCTAssertEqual(results[0].name, "Baked salmon with fennel & tomatoes", "First result is Baked salmon with fennel & tomatoes")
        XCTAssertEqual(results[1].name, "Cajun spiced fish tacos", "Second result is Cajun spiced fish tacos")
    }

    func testRecipesForCategoryWithNoResults() async throws
    {
        let request = RecipesForCategoryRequest(category: "FalseCategory")
        let results = try await request.fetchRecipes()
        
        XCTAssertEqual(results, [], "No search results should mean an empty list")
    }
}
