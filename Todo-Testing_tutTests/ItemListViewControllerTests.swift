//
//  ItemListViewControllerTests.swift
//  Todo-Testing_tutTests
//
//  Created by Elikem Savie (Team Ampersand) on 07/12/2020.
//

import XCTest
@testable import Todo_Testing_tut

class ItemListViewControllerTests: XCTestCase {

    var sut: ItemListViewController!
    var controller: ItemListViewController!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as? ItemListViewController

        _ = sut.view
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_TableViewIsNotNilAfterViewDidLoad() {
        _ = sut.view

        XCTAssertNotNil(sut.tableView)
//        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)

    }
    
    func testViewDidLoad_ShouldSetTableViewDataSource() {
        _ = sut.view
        
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }

    func testViewDidLoad_ShouldSetTableViewDelegate() {

        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }

    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject() {
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                       sut.tableView.delegate as? ItemListDataProvider)
    }

}
