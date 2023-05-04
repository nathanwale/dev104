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
    
    
    // MARK: - properties
    var fetchImageTask: Task<Void, Never>? = nil
    var saved = false
    
    // MARK: - lifecycle
    // cancel fetch image task on deinit
    deinit {
        fetchImageTask?.cancel()
    }
    
    // MARK: - update
    func update(with recipeListItem: RecipeListItem, saved: Bool)
    {
        self.saved = saved
        updateSaveButton()
        nameLabel.text = recipeListItem.name
        fetchImage(for: recipeListItem.imageUrl)
        recipeImageView.layer.cornerRadius = 10
    }
    
    func updateSaveButton()
    {
        if saved {
            saveButton.setTitle("Unsave", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
        }
    }
    
    
    // MARK: - actions
    @IBAction func savePressed()
    {
        saved.toggle()
        updateSaveButton()
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