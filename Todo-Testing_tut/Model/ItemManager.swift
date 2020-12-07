//
//  ItemManager.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 02/12/2020.
//

import Foundation

class ItemManager {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }

    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()

    func addItem(item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }    }

    func itemAtIndex(index: Int) -> ToDoItem {
        return toDoItems[index]
    }

    func checkItemAtIndex(index: Int) {
        let item = toDoItems.remove(at: index)
         doneItems.append(item)
    }

    func uncheckItemAt(index: Int){
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }

    func doneItemAtIndex(index: Int) -> ToDoItem {
        return doneItems[index]
    }

    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }

}


