//
//  ToDoItem.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 30/11/2020.
//

import Foundation

struct ToDoItem {
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?

    init(title: String,
         itemDescription: String? = nil,
         timestamp: Double? = nil,
         location: Location? = nil
         ) {

        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }

}

extension ToDoItem: Equatable {
    static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.location?.name != rhs.location?.name {
            return false
        }

        if lhs.location != rhs.location {
            return false
        }

        if lhs.timestamp != rhs.timestamp {
            return false
        }

        if lhs.itemDescription != rhs.itemDescription {
            return false
        }

        if lhs.title != rhs.title {
            return false
        }


        return true
    }
}
