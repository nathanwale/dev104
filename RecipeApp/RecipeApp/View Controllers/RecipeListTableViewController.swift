//
//  RecipeListTableViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 19/4/2023.
//

import UIKit

//
// Generic list of recipes.
// ...intended to be subclassed
// ...requires a SaveRecipeDelegate
//
class RecipeListTableViewController:
    UITableViewController,
    RequiresSaveRecipeDelegate
{
    // reuse id for table cells
    let reuseIdentifier = "Recipe"
    let emptyMessageCellIdentifier = "Empty"
    let cellNibName = "RecipeTableCell"
    
    // MARK: - properties
    // data source
    var dataSource: DataSource?
    var saveRecipeDelegate: SaveRecipeDelegate!
    
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
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        // update nav
        AppState.shared.navigation = navigationForView()
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
            saveDelegate: self.saveRecipeDelegate)
        
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
        if model.snapshot.indexOfSection(.main) == nil
            || model.snapshot.numberOfItems(inSection: .main) == 0 {
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
    
    
    // MARK: - save handling
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
    
    
    // MARK: - App state nav
    //
    // Navigation when view appears
    //
    func navigationForView() -> AppNavigation
    {
        fatalError("navigationForView not implemented")
    }
    
    
    //
    // Navigation when recipe row selected
    //
    func navigationForSelectedRecipe(identifier: RecipeIdentifier) -> AppNavigation
    {
        fatalError("navigationForSelectedRecipe(identifier: RecipeIdentifier) not implemented")
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
            return UserRecipeStore.shared.isSaved(recipe: item)
        }
    }
}


// MARK: - nav
extension RecipeListTableViewController
{
    //
    // Prepare for segue for showing recipe detail
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if
            let itemId = sender as? RecipeIdentifier,
            let vc = segue.destination as? RecipeDetailViewController
        {
            vc.configure(recipeIdentifier: itemId)
            vc.saveRecipeDelegate = self.saveRecipeDelegate
        }
    }
    
    
    //
    // Row was selected, perform show recipe segue
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemId = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        
        
        AppState.shared.navigation = navigationForSelectedRecipe(identifier: itemId)
        performSegue(withIdentifier: "ShowRecipeDetail", sender: itemId)
    }
}
