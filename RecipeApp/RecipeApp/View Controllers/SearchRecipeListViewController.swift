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
    var searchController = UISearchController()
    
    deinit {
        searchTask?.cancel()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureSearch()
    }

    // MARK: - search
    //
    // configure search
    //
    func configureSearch()
    {
         
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsSearchResultsController = true
    }
    
    
    //
    // search recipes for `searchTerm`
    //
    @objc func fetchSearchedItems()
    {
        let searchTerm = searchController.searchBar.text ?? ""
        print("Searching for ", searchTerm)
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
    // update an item that's had its save state changed
    //
    func updateSaveState(recipe: RecipeListItem, saved: Bool)
    {
        guard let cell = cellFor(recipe: recipe) else {
            return
        }
        
        cell.saved = saved
        cell.updateSaveButton()
    }
}



//
// Conformance to UISearchResultsUpdating
//
extension SearchRecipeListViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchSearchedItems), object: nil)
        perform(#selector(fetchSearchedItems), with: nil, afterDelay: 0.3)
    }
}
