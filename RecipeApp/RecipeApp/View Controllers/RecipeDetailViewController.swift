//
//  RecipeDetailViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 11/5/2023.
//

import UIKit

//
// Show recipe details
// ...requires SaveRecipeDelegate
// ...has an animated overlay when loading
// ...fetches recipe detail and image from remote server
//
class RecipeDetailViewController:
    UIViewController,
    RequiresSaveRecipeDelegate,
    AnimatedLoadingOverlay
{
    // MARK: - outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeInstructionsLabel: UILabel!
    @IBOutlet var ingredientsTableHeight: NSLayoutConstraint!
    @IBOutlet var loadingOverlay: UIView!
    @IBOutlet var saveButton: UIButton!
    
    
    // MARK: - properties
    // recipe detail
    var recipeDetail: RecipeDetail!
    // recipe ID
    var recipeIdentifier: RecipeIdentifier!
    // save recipe delegate
    var saveRecipeDelegate: SaveRecipeDelegate!
    
    // has this recipe been saved?
    var isSaved = false
    
    // tasks for fetching detail and image
    var fetchDetailTask: Task<Void, Never>? = nil
    var fetchImageTask: Task<Void, Never>? = nil
    
    // ingredients table view controller
    var ingredientsTableViewController: IngredientsTableViewController!
    
    
    // MARK: - lifecycle
    //
    // View did load:
    //  - start loading animation
    //  - assign ingredients table View Controller
    //  - start fetching info from API
    //
    override func viewDidLoad()
    {
        // start loading animation
        startLoadingAnimation()
        
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
        // assign recipe
        self.recipeDetail = recipeDetail
        
        // update is saved
        isSaved = UserRecipeStore.shared.isSaved(recipe: recipeDetail.listItem)
        
        // update save button
        updateSaveButton()
        
        // recipe name
        nameLabel.text = recipeDetail.name
        
        // instructions
        recipeInstructionsLabel.text = recipeDetail.instructions
        
        // update ingredients table
        updateIngredientsTable(ingredients: recipeDetail.ingredients)
        
        // stop loading animation
        stopLoadingAnimation()
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
    func fetchImage(for url: URL?)
    {
        guard let url = url else {
            return
        }
        
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
    
    
    // MARK: - saving
    //
    // Save button pressed, update save state
    //
    @IBAction func savePressed()
    {
        isSaved.toggle()
        updateSaveState()
        updateSaveButton()
    }
    
    
    //
    // update save button title
    //
    func updateSaveButton()
    {
        // is it saved?
        if isSaved {
            // if saved, button should now say "Unsave"
            saveButton.setTitle("Unsave", for: .normal)
        } else {
            // if not saved, button should now say "Save"
            saveButton.setTitle("Save", for: .normal)
        }
    }
    
    
    //
    // update recipe save state
    //
    func updateSaveState()
    {
        // is it saved?
        if isSaved {
            // if saved, unsave
            saveRecipeDelegate.save(recipe: recipeDetail.listItem)
        } else {
            // if not saved, save
            saveRecipeDelegate.unsave(recipe: recipeDetail.listItem)
        }
    }
}
