//
//  ItemCell.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 29/12/2020.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCellWithItem(item: ToDoItem, checked: Bool = false) {
        
        if checked {
            let attributedTitle = NSAttributedString(
                string: item.title,
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            
            titleLabel.attributedText = attributedTitle
            locationLabel.text = nil
            dateLabel.text = nil
        } else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name

            if let timestamp = item.timestamp {
                let date = Date(timeIntervalSince1970: timestamp)

                dateLabel.text = dateFormatter.string(from: date)
            }
        }
    }



}
