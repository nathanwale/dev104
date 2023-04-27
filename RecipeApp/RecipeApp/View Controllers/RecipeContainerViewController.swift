//
//  ViewController.swift
//  RecipeApp
//
//  Created by Nathan Wale on 27/3/2023.
//

import UIKit

class RecipeContainerViewController: UIViewController
{
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    
    enum Segment: String {
        case favourites = "Favourites"
        case search = "Search"
        case categories = "Categories"
        
        static var order: [Self] {
            [.favourites, .search, .categories]
        }
        
        static func forIndex(index: Int) -> Self
        {
            order[index]
        }
        
        var segueIdentifier: String {
            switch self {
                case .favourites:
                    return "showFavourites"
                case .search:
                    return "showSearch"
                case .categories:
                    return "showCategories"
            }
        }
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for (i, segment) in Segment.order.enumerated() {
            segmentedControl.setTitle(segment.rawValue, forSegmentAt: i)
        }
    }

    @IBAction func switchEmbeddedView(_ sender: UISegmentedControl)
    {
        let i = sender.selectedSegmentIndex
        guard let tabBarContoller = children.first as? UITabBarController else {
            fatalError("No embedded tab bar controller")
        }
        tabBarContoller.selectedIndex = i
    }
    
    
    
}

