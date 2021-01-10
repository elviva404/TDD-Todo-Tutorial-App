//
//  ItemManager.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 02/12/2020.
//

import UIKit

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }

    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()

    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )

        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }

        return documentURL.appendingPathComponent("toDoItems.plist") as URL
    }

    override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: "save",
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
            
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! [String : Any]) {
                    toDoItems.append(toDoItem)
                }
            }
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }

    func save() {
        var nsToDoItems = [Any]()

        for item in toDoItems {
            nsToDoItems.append(item.plistDict)
        }

        if nsToDoItems.count > 0 {
            (nsToDoItems as NSArray).write(
                to: toDoPathURL,
                atomically: true
            )
        } else {
            do {
                try FileManager.default.removeItem(at: toDoPathURL)
            } catch {
                print(error)
            }
        }
    }

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


