//
//  RecipeListTableViewCell.swift
//  RecipeApp
//
//  Created by Nathan Wale on 19/4/2023.
//

import UIKit

class RecipeListCell: UITableViewCell
{
    // MARK: - outlets
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var newRecipeIndicator: UIView!
    
    
    // MARK: - properties
    var recipe: RecipeListItem!
    var saveDelegate: SaveRecipeDelegate!
    var fetchImageTask: Task<Void, Never>? = nil
    var saved = false
    
    
    // MARK: - lifecycle
    // cancel fetch image task on deinit
    deinit {
        fetchImageTask?.cancel()
    }
    
    
    // MARK: - update
    //
    // update recipe details
    //
    func update(
        with recipeListItem: RecipeListItem,
        saved: Bool,
        saveDelegate: SaveRecipeDelegate)
    {
        accessoryType = .disclosureIndicator
        // assign properties
        self.recipe = recipeListItem
        self.saved = saved
        self.saveDelegate = saveDelegate
        
        // update save button state
        updateSaveButton()
        
        // update newly added state
        updateNewlyAdded()
        
        // update labels and image
        nameLabel.text = recipeListItem.name
        fetchImage(for: recipeListItem.imageUrl)
        recipeImageView.layer.cornerRadius = 10
    }
    
    
    //
    // update save buton state
    //
    func updateSaveButton()
    {
        if saved {
            saveButton.setTitle("Unsave", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
        }
    }
    
    
    //
    // update recipe saved state
    //
    func updateRecipeSavedState()
    {
        // are we saving or unsaving?
        if saved {
            saveDelegate.save(recipe: recipe)
        } else {
            saveDelegate.unsave(recipe: recipe)
        }
    }
    
    
    //
    // update newly added state
    //
    func updateNewlyAdded()
    {
        newRecipeIndicator.isHidden = !recipe.newlyAdded
        animateNewIndicator()
    }
    
    
    // MARK: - animation
    func animateNewIndicator()
    {
        if recipe.newlyAdded {
            for view in self.newRecipeIndicator.subviews {
                UIView.animate(
                    withDuration: 2.0,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0.1,
                    options: [.repeat])
                {
                        
                    view.transform = view.transform.rotated(by: .pi * 1)
                    view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            }
        } else {
            newRecipeIndicator.layer.removeAllAnimations()
        }
    }
    
    // MARK: - actions
    //
    // When save button pressed:
    //  - update save button state
    //  - save or unsave
    //
    @IBAction func savePressed()
    {
        saved.toggle()
        
        // update button
        updateSaveButton()
        
        // save or unsave recipe
        updateRecipeSavedState()
    }
    
    
    // MARK: - remote requests
    //
    // fetch and update recipe image
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
