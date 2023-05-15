//
//  RecipeDetailViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 11/5/2023.
//

import UIKit

class RecipeDetailViewController: UIViewController
{
    // MARK: - outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeInstructionsLabel: UILabel!
    @IBOutlet var ingredientsTableHeight: NSLayoutConstraint!
    
    
    // MARK: - properties
    // recipe ID
    var recipeIdentifier: RecipeIdentifier!
    
    // tasks for fetching detail and image
    var fetchDetailTask: Task<Void, Never>? = nil
    var fetchImageTask: Task<Void, Never>? = nil
    
    // ingredients table view controller
    var ingredientsTableViewController: IngredientsTableViewController!
    
    
    // MARK: - lifecycle
    override func viewDidLoad()
    {
        // assign ingredients table VC
        ingredientsTableViewController = (children.first as! IngredientsTableViewController)
                
        // start fetching remote info and image
        fetchDetail(for: recipeIdentifier)
    }
    
    
    // MARK: - configure
    //
    // Configure view
    //
    func configure(recipeIdentifier: RecipeIdentifier)
    {
        self.recipeIdentifier = recipeIdentifier
    }
    
    
    //
    // Update details
    //
    func updateDetail(recipeDetail: RecipeDetail)
    {
        // recipe name
        nameLabel.text = recipeDetail.name
        
        // instructions
        recipeInstructionsLabel.text = recipeDetail.instructions
        
        // update ingredients table
        updateIngredientsTable(ingredients: recipeDetail.ingredients)
    }
    
    
    //
    // Update ingredients table
    //
    func updateIngredientsTable(ingredients: [IngredientMeasurement])
    {
        // load ingredients into table
        ingredientsTableViewController.configure(with: ingredients)
        
        // adjust table height to fit content
        let tableHeight = ingredientsTableViewController.tableView.contentSize.height
        ingredientsTableHeight.constant = tableHeight
    }
    
    
    // MARK: - remote
    //
    // Fetch recipe details
    //
    func fetchDetail(for id: RecipeIdentifier)
    {
        let request = RecipeDetailRequest(recipeIdentifier: id)
        
        // cancel image task if it exists
        fetchDetailTask?.cancel()
        
        // start task to fetch image
        Task {
            do {
                // fetch image and assign to `recipeImageView`
                let detail = try await request.fetchRecipeDetail()
                updateDetail(recipeDetail: detail)
                fetchImage(for: detail.imageUrl)
            } catch {
                // error
                print(error)
            }
            // finish task
            fetchDetailTask = nil
        }
    }
    
    
    //
    // Fetch recipe image
    //
    func fetchImage(for url: URL)
    {
        let request = ImageRequest(url: url)
        
        // cancel image task if it exists
        fetchImageTask?.cancel()
        
        // start task to fetch image
        Task {
            do {
                // fetch image and assign to `recipeImageView`
                let image = try await request.send()
                recipeImageView.image = image
            } catch {
                // error
                print(error)
            }
            // finish task
            fetchImageTask = nil
        }
    }
}
