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

    init?(dict: [String: Any]) {
        guard let title = dict[titleKey] as? String else
        { return nil }
        
        self.title = title
        
        self.itemDescription = dict[itemDescriptionKey] as? String
        self.timestamp = dict[timestampKey] as? Double
        if let locationDict = dict[locationKey] as?  [String: Any] {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
    }

    private let titleKey = "titleKey"
    private let itemDescriptionKey = "itemDescriptionKey"
    private let timestampKey = "timestampKey"
    private let locationKey = "locationKey"

    var plistDict: [String: Any] {
        var dict = [String: Any]()

        dict[titleKey] = title
        if let itemDescription = itemDescription {
            dict[itemDescriptionKey] = itemDescription
        }
        if let timestamp = timestamp {
            dict[timestampKey] = timestamp
        }
        if let location = location {
            let locationDict = location.plistDict
            dict[locationKey] = locationDict
        }
        return dict
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
