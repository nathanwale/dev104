//
//  SearchRecipeListViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit

class SearchRecipeListViewController: RecipeListTableViewController
{
    
    // search task
    var searchTask: Task<Void, Never>? = nil
    
    deinit {
        searchTask?.cancel()
    }
    
    override func loadItems()
    {
        fetchSearchedItems(searchTerm: "chicken")
    }

    // MARK: - search
    //
    // search recipes for `searchTerm`
    //
    func fetchSearchedItems(searchTerm: String)
    {
        let request = RecipeSearchRequest(searchTerm: searchTerm)
        // cancel task if exists
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                let items = try await request.fetchSearchResults()
                replaceItems(items: items)
            } catch {
                replaceItems(items: [])
                print(error)
            }
            // update datasource
            updateDataSource()
            // finish task
            searchTask = nil
        }
    }
    
    
    // MARK: - update
    //
    // update an item that's had it's save state changed
    //
    func updateSaveSate(recipe: RecipeListItem, saved: Bool)
    {
        if let indexPath = dataSource.indexPath(for: recipe) {
            let cell = tableView.cellForRow(at: indexPath) as! RecipeListCell
            cell.saved = saved
            cell.updateSaveButton()
        }
    }
}
