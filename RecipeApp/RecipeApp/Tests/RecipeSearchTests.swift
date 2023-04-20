//
//  RecipeSearchTest.swift
//  RecipeAppTests
//
//  Created by Nathan Wale on 11/4/2023.
//

import XCTest
@testable import RecipeApp

final class RecipeSearchTests: XCTestCase {

    func testRecipeSearchWithResults() async throws
    {
        let request = RecipeSearchRequest(searchTerm: "chicken")
        let results = try await request.fetchSearchResults()
        
        XCTAssertGreaterThan(results.count, 0, "Search result list is not empty")
        XCTAssertEqual(results[0].name, "Chicken Handi", "First result is Chicken Handi")
        XCTAssertEqual(results[1].name, "Chicken Congee", "Second result is Chicken Congee")
    }

    func testRecipeSearchWithNoResults() async throws
    {
        let request = RecipeSearchRequest(searchTerm: "abcdef")
        let results = try await request.fetchSearchResults()
        
        XCTAssertEqual(results, [], "No search results should mean an empty list")
    }
}
