//
//  CategoryListApiTests.swift
//  RecipeAppTests
//
//  Created by Nathan Wale on 11/4/2023.
//

import XCTest
@testable import RecipeApp

final class CategoryListApiTests: XCTestCase {

    func testFetchCategoryList() async throws
    {
        let request = RecipeCategoryListRequest()
        let categories = try await request.fetchCategories()
        
        XCTAssertGreaterThan(categories.count, 0, "Category list is not empty")
        XCTAssertEqual(categories[0], "Beef")
        XCTAssertEqual(categories[1], "Breakfast")
    }

}
