//
//  RecipeListTableViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 19/4/2023.
//

import UIKit

class RecipeListTableViewController: UITableViewController
{
    // reuse id for table cells
    let reuseIdentifier = "Recipe"
    
    
    // MARK: - view model
    // data source type
    typealias DataSource = UITableViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel
    {
        enum Section { case main }
        typealias Item = RecipeListItem
    }
    
    struct Model
    {
        var favouriteItems = [RecipeListItem]()
        var searchedItems = [RecipeListItem]()
    }
    
    // MARK: - properties
    // data source
    var dataSource: DataSource!
    
    // model
    var model = Model()
    
    // snapshot
    var itemsSnapshot: DataSourceSnapshot {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(model.searchedItems)
        return snapshot
    }
    
    // fetch tasks
    var fetchTask: Task<Void, Never>? = nil
    
    
    // MARK: - lifecycle
    // cancel tasks on exit
    deinit {
        fetchTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = createDataSource()
        tableView.dataSource = dataSource
        
        fetchSearchedItems()
    }

    
    // MARK: - data source
    //
    // Create datasource
    //
    func createDataSource() -> DataSource
    {
        let dataSource = DataSource(tableView: tableView) {
            (tableView, indexPath, item) -> UITableViewCell?
            in
            
            // get cell
            let cell = tableView.dequeueReusableCell(
                withIdentifier: self.reuseIdentifier,
                for: indexPath) as! RecipeListTableViewCell
            
            // configure cell
            cell.update(with: item)
            
            // return cell
            return cell
        }
        
        return dataSource
    }
    
    
    //
    // Update datasource
    //
    func updateDataSource()
    {
        dataSource.apply(itemsSnapshot, animatingDifferences: true)
    }
    
    
    // MARK: - search
    func fetchSearchedItems()
    {
        let request = RecipeSearchRequest(searchTerm: "chicken")
        // cancel task if exists
        fetchTask?.cancel()
        
        fetchTask = Task {
            do {
                let items = try await request.fetchSearchResults()
                model.searchedItems = items
            } catch {
                model.searchedItems = []
                print(error)
            }
            // update datasource
            updateDataSource()
            // finish task
            fetchTask = nil
        }
    }
}
