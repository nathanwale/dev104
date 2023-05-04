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
    let cellNibName = "RecipeTableCell"
    
    // MARK: - properties
    // data source
    var dataSource: DataSource?
    var saveDelegate: SaveRecipeDelegate!
    
    // model
    private var model = Model()

    
    // MARK: - lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // load custom NIB and register with table
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: cellNibName, bundle: bundle)
        
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        // setup and attach datasource
        dataSource = createDataSource()
        tableView.dataSource = dataSource
        
        // load items. this method is for specialisation in subclasses
        loadItems()
    }

    
    // override to load items in subclass
    func loadItems() {}
    
    
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
                for: indexPath) as! RecipeListCell
            
            // has this item been saved?
            let saved = self.model.isSaved(item: item)
            
            // configure cell
            cell.update(
                with: item,
                saved: saved,
                saveDelegate: self.saveDelegate)
            
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
        dataSource?.apply(model.snapshot, animatingDifferences: true)
    }
    
    
    //
    // replace items
    //
    func replaceItems(items: [RecipeListItem])
    {
        model.snapshot.deleteAllItems()
        model.snapshot.appendSections([.main])
        model.snapshot.appendItems(items)
        dataSource?.apply(model.snapshot)
    }
    
    
    //
    // add item
    //
    func addItem(_ item: ViewModel.Item)
    {
        model.snapshot.appendItems([item])
        dataSource?.apply(model.snapshot)
    }
    
    
    //
    // remove item
    //
    func removeItem(_ item: ViewModel.Item)
    {
        model.snapshot.deleteItems([item])
        dataSource?.apply(model.snapshot)
    }
    
    //
    // get cell for recipe
    //
    func cellFor(recipe: RecipeListItem) -> RecipeListCell?
    {
        guard
            let indexPath = dataSource?.indexPath(for: recipe),
            let cell = tableView.cellForRow(at: indexPath) as? RecipeListCell
        else {
            return nil
        }
        
        return cell
    }
}


// MARK: - view model
extension RecipeListTableViewController
{
    // data source type
    typealias DataSource = UITableViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>

    // view model
    enum ViewModel
    {
        enum Section { case main }
        typealias Item = RecipeListItem
    }
    
    // model model
    struct Model
    {
        // items
        var items = [RecipeListItem]()
        // snapshot
        var snapshot = DataSourceSnapshot()
        
        // has the item been saved?
        func isSaved(item: ViewModel.Item) -> Bool
        {
            UserStore.savedRecipes.contains(item)
        }
    }
}
