//
//  InputViewController.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 06/01/2021.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func save() {
        guard let titleString = titleTextField.text, titleString.count > 0 else { return }
        let date: Date?
        if let dateText = self.dateTextField.text, dateText.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }

        let descriptionString: String?
        if descriptionTextField.text?.count ?? 0 > 0 {
            descriptionString = descriptionTextField.text
        } else {
            descriptionString = nil
        }

        if let locationName = locationTextField.text, locationName.count > 0 {
            if let address = addressTextField.text, address.count > 0 {
                
                geocoder.geocodeAddressString(address) {
                    [unowned self] (placeMarks, error) -> Void in
                    
                    let placeMark = placeMarks?.first
                    
                    let item = ToDoItem(
                        title: titleString,
                        itemDescription: descriptionString,
                        timestamp: date?.timeIntervalSince1970,
                        location: Location(
                            name: locationName,
                            coordinate: placeMark?.location?.coordinate)
                    )

                    DispatchQueue.main.async {
                        self.itemManager?.addItem(item: item)
                        self.dismiss(
                            animated: true,
                            completion: nil
                        )
                    }
    
                    
                    self.itemManager?.addItem(item: item)
                }
            } else {
                let item = ToDoItem(title: titleString,
                    itemDescription: descriptionString,
                    timestamp: date?.timeIntervalSince1970,
                    location: Location(name: locationName))
                
                self.itemManager?.addItem(item: item)
                dismiss(animated: true, completion: nil)
            }
    } else {
        let item = ToDoItem(title: titleString,
            itemDescription: descriptionString,
            timestamp: date?.timeIntervalSince1970,
            location: nil)
        
        self.itemManager?.addItem(item: item)

        dismiss(animated: true, completion: nil)

    }
    }

}
