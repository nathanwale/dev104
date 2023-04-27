//
//  RecipeSearchTest.swift
//  RecipeAppTests
//
//  Created by Nathan Wale on 11/4/2023.
//

import XCTest
@testable import RecipeApp

final class RecipeListItemTests: XCTestCase {

    func testRecipeListItemById() async throws
    {
        let request = RecipeListItemRequest(recipeIdentifier: "52816")
        let result = try await request.fetchRecipeListItem()
        
        XCTAssertEqual(
            result.identifier,
            "52816",
            "ID is 52816")
        XCTAssertEqual(
            result.name,
            "Roasted Eggplant With Tahini, Pine Nuts, and Lentils",
            "Name is Roasted Eggplant...")
        XCTAssertEqual(
            result.imageUrl.absoluteString,
            "https://www.themealdb.com/images/media/meals/ysqrus1487425681.jpg",
            "Image URL is ...")
    }
    
    func testFetchNonExistentRecipeListItem() async throws
    {
        let nonExistendIdentifier = "-1"
        let request = RecipeListItemRequest(recipeIdentifier: nonExistendIdentifier)
        do {
            let _ = try await request.fetchRecipeListItem()
            XCTFail("This recipe shouldn't exist, and fetch should throw an ApiRequest.notFound error")
        } catch {
            XCTAssertEqual(error as? ApiRequestError, .notFound)
        }
        
    }
}
