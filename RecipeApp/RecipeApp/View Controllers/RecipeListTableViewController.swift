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
    let emptyMessageCellIdentifier = "Empty"
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
            (tableView, indexPath, itemId) -> UITableViewCell?
            in
            
            
            if indexPath.section == ViewModel.Section.main.rawValue {
                // return recipe cell
                return self.recipeCellFor(itemId: itemId, indexPath: indexPath)
            } else {
                // return empty table message cell
                // (ie. to tell the user there's nothing here yet)
                return self.emptyMessageCell()
            }
        }
        
        return dataSource
    }
    
    
    //
    // Recipe cell for index
    //
    func recipeCellFor(itemId: ViewModel.ItemId, indexPath: IndexPath) -> RecipeListCell
    {
        // get item from store
        let item = self.model.itemStore[itemId]!
        
        // get cell
        let cell = tableView.dequeueReusableCell(
            withIdentifier: self.reuseIdentifier,
            for: indexPath) as! RecipeListCell
        
        // has this item been saved?
        let saved = self.model.isSaved(itemId: itemId)
        
        // configure cell
        cell.update(
            with: item,
            saved: saved,
            saveDelegate: self.saveDelegate)
        
        return cell
    }
    
    
    //
    // Empty message cell
    //
    func emptyMessageCell() -> UITableViewCell?
    {
        tableView.dequeueReusableCell(withIdentifier: emptyMessageCellIdentifier)
    }
    
    
    //
    // Update datasource
    //
    func updateDataSource()
    {
        let dummyIdentifiers = ["--empty"]
        if model.snapshot.numberOfItems(inSection: .main) == 0 {
            // not items, so append to empty section
            if !model.snapshot.sectionIdentifiers.contains(.empty) {
                model.snapshot.appendSections([.empty])
            }
            model.snapshot.appendItems(dummyIdentifiers, toSection: .empty)
        } else {
            // we have items, so delete empty section
            model.snapshot.deleteItems(dummyIdentifiers)
        }
        dataSource?.apply(model.snapshot, animatingDifferences: true)
    }
    
    
    //
    // replace items
    //
    func replaceItems(items: [RecipeListItem])
    {
        let itemIds = items.map { $0.identifier }
        
        // update model items
        model.itemStore.removeAll()
        for item in items {
            model.itemStore[item.identifier] = item
        }
        
        // update table datasource
        model.snapshot.deleteAllItems()
        model.snapshot.appendSections([.main])
        model.snapshot.appendItems(itemIds, toSection: .main)
        updateDataSource()
    }
    
    
    //
    // add item
    //
    func addItem(_ item: RecipeListItem)
    {
        model.itemStore[item.identifier] = item
        model.snapshot.appendItems([item.identifier], toSection: .main)
        updateDataSource()
    }
    
    
    //
    // remove item
    //
    func removeItem(_ item: RecipeListItem)
    {
        // remove from table datasource
        model.snapshot.deleteItems([item.identifier])
        updateDataSource()
        
        // remove from model store
        model.itemStore.removeValue(forKey: item.identifier)
    }
    
    
    //
    // update item
    //
    func updateItems(_ items: [RecipeListItem])
    {
        for item in items {
            model.itemStore[item.identifier] = item
        }
        let itemIds = items.map { $0.identifier }
        model.snapshot.reloadItems(itemIds)
        updateDataSource()
    }
    
    
    //
    // get cell for recipe
    //
    func cellFor(recipe: RecipeListItem) -> RecipeListCell?
    {
        guard
            let indexPath = dataSource?.indexPath(for: recipe.identifier),
            let cell = tableView.cellForRow(at: indexPath) as? RecipeListCell
        else {
            // index path or cell couldn't be found
            return nil
        }
        
        // return found cell
        return cell
    }
}


// MARK: - view model
extension RecipeListTableViewController
{
    // data source type
    typealias DataSource = UITableViewDiffableDataSource<ViewModel.Section, ViewModel.ItemId>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.ItemId>

    // view model
    enum ViewModel
    {
        enum Section: Int {
            case main
            case empty
            
            static let all: [Self] = [.main, .empty]
        }
        typealias ItemId = RecipeIdentifier
    }
    
    // model model
    struct Model
    {
        // items
        var itemStore = [RecipeIdentifier: RecipeListItem]()
        // snapshot
        var snapshot = DataSourceSnapshot()
        
        // has the item been saved?
        func isSaved(itemId: ViewModel.ItemId) -> Bool
        {
            let item = itemStore[itemId]!
            return UserRecipeStore.shared.savedRecipes.contains(item)
        }
    }
}
