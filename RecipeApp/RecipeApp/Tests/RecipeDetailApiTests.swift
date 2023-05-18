//
//  RecipeApiTests.swift
//  RecipeApp
//
//  Created by Nathan Wale on 5/4/2023.
//

import XCTest
@testable import RecipeApp


final class RecipeDetailApiTests: XCTestCase
{
    // MARK: - recipe detail by id
    func testFetchSingleRecipe() async throws {
        let instructions = "Preheat oven to 350° F. Spray a 9x13-inch baking pan with non-stick spray.\r\nCombine soy sauce, ½ cup water, brown sugar, ginger and garlic in a small saucepan and cover. Bring to a boil over medium heat. Remove lid and cook for one minute once boiling.\r\nMeanwhile, stir together the corn starch and 2 tablespoons of water in a separate dish until smooth. Once sauce is boiling, add mixture to the saucepan and stir to combine. Cook until the sauce starts to thicken then remove from heat.\r\nPlace the chicken breasts in the prepared pan. Pour one cup of the sauce over top of chicken. Place chicken in oven and bake 35 minutes or until cooked through. Remove from oven and shred chicken in the dish using two forks.\r\n*Meanwhile, steam or cook the vegetables according to package directions.\r\nAdd the cooked vegetables and rice to the casserole dish with the chicken. Add most of the remaining sauce, reserving a bit to drizzle over the top when serving. Gently toss everything together in the casserole dish until combined. Return to oven and cook 15 minutes. Remove from oven and let stand 5 minutes before serving. Drizzle each serving with remaining sauce. Enjoy!"

        let ingredients: [IngredientMeasurement] = [
            IngredientMeasurement(ingredient: "soy sauce", measurement: "3/4 cup"),
            IngredientMeasurement(ingredient: "water", measurement: "1/2 cup"),
            IngredientMeasurement(ingredient: "brown sugar", measurement: "1/4 cup"),
            IngredientMeasurement(ingredient: "ground ginger", measurement: "1/2 teaspoon"),
            IngredientMeasurement(ingredient: "minced garlic", measurement: "1/2 teaspoon"),
            IngredientMeasurement(ingredient: "cornstarch", measurement: "4 Tablespoons"),
            IngredientMeasurement(ingredient: "chicken breasts", measurement: "2"),
            IngredientMeasurement(ingredient: "stir-fry vegetables", measurement: "1 (12 oz.)"),
            IngredientMeasurement(ingredient: "brown rice", measurement: "3 cups"),
        ]
        
        let request = RecipeDetailRequest(recipeIdentifier: "52772")

        let recipe = try await request.fetchRecipeDetail()
        XCTAssertEqual(recipe.identifier, "52772", "Recipe Identifier")
        XCTAssertEqual(recipe.name, "Teriyaki Chicken Casserole", "Recipe Name")
        XCTAssertEqual(recipe.category, "Chicken", "Recipe Category")
        XCTAssertEqual(recipe.region, "Japanese", "Recipe Region")
        XCTAssertEqual(recipe.instructions, instructions, "Recipe Instructions")
        XCTAssertEqual(recipe.imageUrl?.absoluteString, "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg", "Recipe Image URL")
        XCTAssertEqual(recipe.videoUrl?.absoluteString, "https://www.youtube.com/watch?v=4aZr5hZXP_s", "Recipe Video URL")
        XCTAssertEqual(recipe.tags.count, 2, "Recipe tag count")
        XCTAssertEqual(recipe.tags, ["Meat", "Casserole"], "Recipe tags")
        XCTAssertEqual(recipe.ingredients.count, 9, "Recipe ingredient count")
        XCTAssertEqual(recipe.ingredients, ingredients, "Recipe ingredients")
        
            
    }
    
    
    // MARK: - recipe not found
    func testFetchNonExistentRecipeDetail() async throws {
        let nonExistendIdentifier = "-1"
        let request = RecipeDetailRequest(recipeIdentifier: nonExistendIdentifier)
        do {
            let _ = try await request.fetchRecipeDetail()
            XCTFail("This recipe shouldn't exist, and fetch should throw an ApiRequest.notFound error")
        } catch {
            XCTAssertEqual(error as? ApiRequestError, .notFound)
        }
        
    }
}
