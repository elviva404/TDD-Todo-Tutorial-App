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

    func testItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as? UIViewController,
            sut)
    }

    func testAddItem_PresentsAddItemViewController() {
        
        XCTAssertNil(sut.presentedViewController)
        
        guard let addButton = sut.navigationItem.rightBarButtonItem,
              let action = addButton.action else {
            XCTFail()
            return
        }
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

        keyWindow?.rootViewController = sut

        sut.perform(
            action,
            with: addButton,
            afterDelay: 0
        )
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)

        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)

    }

    func testItemListVC_SharesItemManagerWithInputVC() {
        
        XCTAssertNil(sut.presentedViewController)
        
        guard let addButton = sut.navigationItem.rightBarButtonItem,
              let action = addButton.action else {
            XCTFail()
            return
        }
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

        keyWindow?.rootViewController = sut

        sut.perform(
            action,
            with: addButton,
            afterDelay: 0
        )
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        
        guard let inputItemManager = inputViewController.itemManager else
        { XCTFail(); return }
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }

    func testViewDidLoad_SetsItemManagerToDataProvider() {
//        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }

    func testItemListVC_ReloadTableViewOnViewWillAppear() {

        let mockTableView = MockTableView()
        sut.tableView = mockTableView

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertTrue(mockTableView.hasReloadedTableView)
    }

    func testItemSelectedNotification_PushesDetailVC() {
        
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        _ = sut.view
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "ItemSelectedNotification"),
            object: self,
            userInfo: ["index": 1]
        )
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else { XCTFail(); return }
        
        guard let detailItemManager = detailViewController.itemInfo?.0 else
        { XCTFail(); return }
        
        guard let index = detailViewController.itemInfo?.1 else
        { XCTFail(); return }
        
        _ = detailViewController.view
        
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }

}

extension ItemListViewControllerTests {

    class MockTableView: UITableView {
        
        var hasReloadedTableView = false

        override func reloadData() {
            hasReloadedTableView = true
            super.reloadData()
        }

    }

    class MockNavigationController : UINavigationController {

        var pushedViewController: UIViewController?

        override func pushViewController(
            _ viewController: UIViewController,
            animated: Bool
        ) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }


}
