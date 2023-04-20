//
//  IngredientListApiTests.swift
//  RecipeAppTests
//
//  Created by Nathan Wale on 11/4/2023.
//

import XCTest
@testable import RecipeApp

final class IngredientListApiTests: XCTestCase
{
    func testFetchIngredientList() async throws
    {
        let request = IngredientListRequest()
        let ingredients = try await request.fetchIngredients()
        
        XCTAssertGreaterThan(ingredients.count, 0, "Ingredients list is not empty")
        XCTAssertEqual(ingredients[0], "Chicken")
        XCTAssertEqual(ingredients[1], "Salmon")
    }
}
