//
//  ItemListDataProviderTests.swift
//  Todo-Testing_tutTests
//
//  Created by Elikem Savie (Team Ampersand) on 26/12/2020.
//

import XCTest
@testable import Todo_Testing_tut

class ItemListDataProviderTests: XCTestCase {
    
    var sut: ItemListDataProvider!
    var tableView: UITableView!
    var controller: ItemListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(
            withIdentifier: "ItemListViewController"
        ) as? ItemListViewController
        
        _ = controller.view
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.itemManager?.removeAllItems()
        sut.itemManager = nil
    }

    func testNumberOfSections_IsTwo() {
        tableView.dataSource = sut
        
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }

    func testNumberRowsInFirstSection_IsToDoCount() {
        tableView.dataSource = sut

        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)

        sut.itemManager?.addItem(item: ToDoItem(title: "Second"))

        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }

    func testNumberRowsInSecondSection_IsDoneCount() {
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        sut.itemManager?.addItem(item: ToDoItem(title: "Second"))
        sut.itemManager?.checkItemAtIndex(index: 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.itemManager?.checkItemAtIndex(index: 0)
        tableView.reloadData()
        
//        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)

    }
    
    func testCellForRow_ReturnsItemCell() {
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(
            at: NSIndexPath(row: 0,section: 0) as IndexPath
        )
        
        XCTAssertTrue(cell is ItemCell)
    }

    func testCellForRow_DequeuesCell() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(
            at: NSIndexPath(row: 0, section: 0) as IndexPath
        )
        
//        XCTAssertTrue(mockTableView.cellGotDequeued)
    }

    func testConfigCell_GetsCalledInCellForRow() {
        
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)

        let toDoItem = ToDoItem(
            title: "First",
            itemDescription: "First description"
        )
        sut.itemManager?.addItem(item: toDoItem)
        mockTableView.reloadData()
        
//        let cell = mockTableView.cellForRow(
//            at: NSIndexPath(
//                row: 0,
//                section: 0) as IndexPath) as! MockItemCell
//
//
//        XCTAssertEqual(cell.toDoItem, toDoItem)
    }

    func testCellInSectionTwo_GetsConfiguredWithDoneItem() {
        
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)

        
        let firstItem = ToDoItem(title: "First",
            itemDescription: "First description")
        sut.itemManager?.addItem(item: firstItem)
        
        let secondItem = ToDoItem(title: "Second",
            itemDescription: "Second description")
        sut.itemManager?.addItem(item: secondItem)
        
        sut.itemManager?.checkItemAtIndex(index: 1)
        mockTableView.reloadData()
        
        guard let cell = mockTableView.cellForRow(
            at: IndexPath(row: 0, section: 1)
        ) as? MockItemCell else {
            return
        }
        
        XCTAssertEqual(cell.toDoItem, secondItem)
    }

    func testDeletionButtonInFirstSection_ShowsTitleCheck() {

        let deleteButtonTitle = tableView.delegate?.tableView?(
            tableView,
            titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0)
        )

        XCTAssertEqual(deleteButtonTitle, "Check")
    }

    func testDataSourceAndDelegate_AreNotTheSameObject() {
        XCTAssert(tableView.dataSource is ItemListDataProvider)
        XCTAssert(tableView.delegate is ItemListDataProvider)
        
        XCTAssertNotEqual(tableView.dataSource as? ItemListDataProvider,
            tableView.delegate as? ItemListDataProvider)
    }

    func testDeletionButtonInFirstSection_ShowsTitleUncheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(
            tableView,
            titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1)
        )

//        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }

    func testSelectingACell_SendsNotification() {
        let item = ToDoItem(title: "First")
        sut.itemManager?.addItem(item: item)
        
        expectation(
            forNotification: NSNotification.Name(rawValue: "ItemSelectedNotification"),
            object: nil
        ) { (notification) -> Bool in
            
            guard let index = notification.userInfo?["index"] as? Int else { return false }
            return index == 0
        }
        
        tableView.delegate?.tableView?(
            tableView,
            didSelectRowAt: IndexPath(row: 0, section: 0)
        )
        
        waitForExpectations(timeout: 3, handler: nil)
    }

}


extension ItemListDataProviderTests {

    class MockTableView: UITableView {
        
        var cellGotDequeued = false
        var itemManager: ItemManager?

        class func mockTableViewWithDataSource(
            dataSource: UITableViewDataSource) -> MockTableView {
            
            let mockTableView = MockTableView(
                frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                style: .plain)
            
            mockTableView.dataSource = dataSource
            mockTableView.register(
                MockItemCell.self,
                forCellReuseIdentifier: "ItemCell"
            )
            
            return mockTableView
        }

        override func dequeueReusableCell(
            withIdentifier identifier: String,
            for indexPath: IndexPath) -> UITableViewCell {
            
            cellGotDequeued = true

            return super.dequeueReusableCell(
                withIdentifier: identifier,
                for: indexPath as IndexPath)
        }

        func tableView(tableView: UITableView,
                       cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ItemCell",
                for: indexPath as IndexPath) as! ItemCell
            
            guard let itemManager = itemManager else { fatalError() }
            guard let section = Section(rawValue: indexPath.section) else
            {
                fatalError()
            }
            
            let item: ToDoItem
            switch section {
            case .ToDo:
                item = itemManager.itemAtIndex(index: indexPath.row)
            case .Done:
                item = itemManager.doneItemAtIndex(index: indexPath.row)
            }
            
            cell.configCellWithItem(item: item)
            
            return cell
        }

    }

    class MockItemCell : ItemCell {
        
        var toDoItem: ToDoItem?

        override func configCellWithItem(item: ToDoItem, checked: Bool = false) {
            toDoItem = item
        }
    }
}

