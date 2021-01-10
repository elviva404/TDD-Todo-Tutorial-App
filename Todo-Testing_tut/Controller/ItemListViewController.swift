//
//  ItemListViewControllerTests.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 07/12/2020.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet var dataProvider: ItemListDataProvider!
    
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider


    }

}
