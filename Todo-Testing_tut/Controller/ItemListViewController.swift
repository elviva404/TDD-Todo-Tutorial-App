//
//  ItemListViewControllerTests.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 07/12/2020.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!

    let itemManager = ItemManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager

        NotificationCenter.default.addObserver(
            self,
            selector: Selector("showDetails:"),
            name: NSNotification.Name(rawValue: "ItemSelectedNotification"),
            object: nil
        )

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func showDetails(sender: NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else
        { fatalError() }

        if let nextViewController = storyboard?.instantiateViewController(
            withIdentifier: "DetailViewController"
        ) as? DetailViewController {

            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(
                nextViewController,
                animated: true
            )
        }
    }


    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController")
        as? InputViewController {
            nextViewController.itemManager = ItemManager()
            present(nextViewController, animated: true, completion: nil)
        }

    }
    
    
}
