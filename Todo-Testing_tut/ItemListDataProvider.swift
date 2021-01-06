//
//  ItemListDataProvider.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 23/12/2020.
//

import UIKit


enum Section: Int {
    case ToDo
    case Done
}

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {

    var itemManager: ItemManager?

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemManager = itemManager else { return 0 }
        
        guard let itemSection = Section(rawValue: section) else {
            fatalError()
        }

        let numberOfRows: Int
        switch itemSection {
        case .ToDo:
            numberOfRows = itemManager.toDoCount
        case .Done:
            numberOfRows = itemManager.doneCount
        }

        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ItemCell()
    }

    func tableView(tableView: UITableView,
        titleForDeleteConfirmationButtonForRowAtIndexPath indexPath:
        NSIndexPath) -> String? {
            
            guard let section = Section(rawValue: indexPath.section) else
            {
                fatalError()
            }
            
            let buttonTitle: String
            switch section {
            case .ToDo:
                buttonTitle = "Check"
            case .Done:
                buttonTitle = "Uncheck"
            }
            
            return buttonTitle
    }


}
