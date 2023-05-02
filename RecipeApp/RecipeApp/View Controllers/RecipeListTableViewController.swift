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
    var dataSource: DataSource!
    
    // model
    private var model = Model()

    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load custom NIB and register with table
        let nib = UINib.init(nibName: cellNibName, bundle: nil)
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
            
            // configure cell
            cell.update(with: item, saved: true)
            
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
        dataSource.apply(model.snapshot, animatingDifferences: true)
    }
    
    
    //
    // replace items
    //
    func replaceItems(items: [RecipeListItem])
    {
        model.snapshot.deleteAllItems()
        model.snapshot.appendSections([.main])
        model.snapshot.appendItems(items)
        dataSource.apply(model.snapshot)
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
    }
}
