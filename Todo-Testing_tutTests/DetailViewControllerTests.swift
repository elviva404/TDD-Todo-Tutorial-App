//
//  DetailViewController.swift
//  Todo-Testing_tutTests
//
//  Created by Elikem Savie (Team Ampersand) on 06/01/2021.
//

@testable import Todo_Testing_tut
import XCTest
import MapKit
import CoreLocation


class DetailViewControllerTests: XCTestCase {

    var sut = DetailViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main",
            bundle: nil)
         sut = storyboard.instantiateViewController(
            withIdentifier: "DetailViewController") as! DetailViewController

        _ = sut.view
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.itemInfo?.0.removeAllItems()
    }

    func test_HasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }

    func test_HasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
    }

    func test_HasDateLabelabel() {
        XCTAssertNotNil(sut.dateLabel)
    }

    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }

    func testSettingItemInfo_SetsTextsToLabels() {
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
        
        let itemManager = ItemManager()
        itemManager.addItem(item: ToDoItem(title: "The title",
                                           itemDescription: "The description",
                                           timestamp: 1456150025,
                                           location: Location(name: "Home", coordinate: coordinate)))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertEqual(sut.titleLabel.text, "The title")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.locationLabel.text, "Home")
        XCTAssertEqual(sut.descriptionLabel.text, "The description")
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude,
            coordinate.latitude,
            accuracy: 0.001)
    }

    func testCheckItem_ChecksItemInItemManager() {
        
        let itemManager = ItemManager()
        itemManager.addItem(item: ToDoItem(title: "The title"))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }

}
