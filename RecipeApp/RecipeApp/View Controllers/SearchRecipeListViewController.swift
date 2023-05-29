//
//  SearchRecipeListViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 21/4/2023.
//

import UIKit

class SearchRecipeListViewController: RecipeListTableViewController
{
    // search term
    var searchTerm: String? {
        get {
            searchController.searchBar.text
        }
        
        set {
            searchController.searchBar.text = newValue
        }
    }
    
    // last searched term
    var lastSearchedTerm = ""
    
    // search task
    var searchTask: Task<Void, Never>? = nil
    var searchController = UISearchController()
    
    
    // MARK: - lifecycle
    deinit {
        searchTask?.cancel()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureSearch()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // search if current search terms haven't been searched yet
        if searchTerm != lastSearchedTerm {
            fetchSearchedItems()
        }
    }
    
    
    // MARK: - navigation
    override func navigationForView() -> AppNavigation
    {
        // update nav
        if lastSearchedTerm != "" {
            return .search(.term(lastSearchedTerm))
        } else {
            return .search(.none)
        }
    }
    
    func updateNavigation(searchTerm: String)
    {
        AppState.shared.navigation = .search(.term(searchTerm))
    }
    
    override func navigationForSelectedRecipe(identifier: RecipeIdentifier) -> AppNavigation
    {
        AppNavigation.search(.recipe(lastSearchedTerm, identifier))
    }
    
    
    // MARK: - search
    //
    // configure search
    //
    func configureSearch()
    {
        // attach search controller to nav
        navigationItem.searchController = searchController
        
        // activate from start
        searchController.isActive = true
        
        // This VC is the search results updater
        searchController.searchResultsUpdater = self
        
        // automatically show results
        searchController.automaticallyShowsSearchResultsController = true
        
        // don't hide nav bar when searching
        searchController.hidesNavigationBarDuringPresentation = false
        
        // don't hid background when searching
        searchController.obscuresBackgroundDuringPresentation = false
        
        // add tab gesture recogniser to end search
        // when pressing outside search bar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endSearch))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    
    //
    // end searching
    //
    @objc func endSearch()
    {
        searchController.isActive = false
    }
    
    
    //
    // search recipes for `searchTerm`
    //
    @objc func fetchSearchedItems()
    {
        guard
            let searchTerm = searchTerm,
            searchTerm != ""
        else {
            // search field is empty or undefined. bail.
            return
        }
        
        print("Searching for ", searchTerm)
        
        // update nav
        updateNavigation(searchTerm: searchTerm)
        
        // create search request
        let request = RecipeSearchRequest(searchTerm: searchTerm)
        
        // cancel task if exists
        searchTask?.cancel()
        
        // create search task
        searchTask = Task {
            do {
                // fetch results and place in table
                let items = try await request.fetchSearchResults()
                replaceItems(items: items)
            } catch {
                // on error empty table and print error
                replaceItems(items: [])
                print(error)
            }
            
            // update datasource
            updateDataSource()
            
            // set last searched term to this one
            lastSearchedTerm = searchTerm
            
            // finish task
            searchTask = nil
        }
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
