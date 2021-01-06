//
//  ItemCellTests.swift
//  Todo-Testing_tutTests
//
//  Created by Elikem Savie (Team Ampersand) on 06/01/2021.
//

import XCTest
@testable import Todo_Testing_tut

class ItemCellTests: XCTestCase {

    var tableView: UITableView?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "ItemListViewController") as! ItemListViewController

        _ = controller.view

        tableView = controller.tableView
        tableView?.dataSource = FakeDataSource()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSUT_HasNameLabel() {

        let cell = tableView?.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: IndexPath(row: 0, section: 0)
        ) as! ItemCell

        XCTAssertNotNil(cell.titleLabel)
    }

    func testSUT_HasLocationLabel() {

        let cell = tableView?.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: IndexPath(row: 0, section: 0)
        ) as! ItemCell
        
        XCTAssertNotNil(cell.locationLabel)
    }

    func testSUT_HasDateLabel() {

        let cell = tableView?.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: IndexPath(row: 0, section: 0)
        ) as! ItemCell

        XCTAssertNotNil(cell.dateLabel)
    }

    func testConfigWithItem_SetsTitle() {
        
        let cell = tableView?.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: IndexPath(row: 0, section: 0)
        ) as! ItemCell
        
        cell.configCellWithItem(item: ToDoItem(title: "First"))
        XCTAssertEqual(cell.titleLabel.text, "First")
    }

    func testConfigWithItem_SetsLabelTexts() {
        
        let cell = tableView?.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: IndexPath(row: 0, section: 0)) as!
            ItemCell
        
        cell.configCellWithItem(
            item: ToDoItem(
                title: "First",
                itemDescription: nil,
                timestamp: 1456150025,
                location: Location(name: "Home")
            )
        )
        
        XCTAssertEqual(cell.titleLabel.text, "First")
        XCTAssertEqual(cell.locationLabel.text, "Home")
        XCTAssertEqual(cell.dateLabel.text, "02/22/2016")
    }

    func testTitle_ForCheckedTasks_IsStrokeThrough() {

        let cell = tableView?.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: IndexPath(row: 0, section: 0)
        ) as! ItemCell

        let toDoItem = ToDoItem(
            title: "First",
            itemDescription: nil,
            timestamp: 1456150025,
            location: Location(name: "Home")
        )
        
        cell.configCellWithItem(item: toDoItem, checked: true)
        
        let attributedString = NSAttributedString(string: "First",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])

        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }

}

extension ItemCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }

        func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {

            return 1
        }
        
    }
}

