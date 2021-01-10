//
//  InputViewControllerTests.swift
//  Todo-Testing_tutTests
//
//  Created by Elikem Savie (Team Ampersand) on 06/01/2021.
//

@testable import Todo_Testing_tut
import XCTest
import CoreLocation

class InputViewControllerTests: XCTestCase {

    var sut: InputViewController!
    var placemark: MockPlacemark!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main",
            bundle: nil)
        sut = storyboard.instantiateViewController(
            withIdentifier: "InputViewController") as! InputViewController

        _ = sut.view

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }

    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }

    func test_HasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }

    func test_HasDescriptonTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }

    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }

    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }

    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.dateTextField.text = "02/22/2016"
        mockInputViewController.locationTextField.text = "Office"
        mockInputViewController.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockInputViewController.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeocoder()
        mockInputViewController.geocoder = mockGeocoder
        
        mockInputViewController.itemManager = ItemManager()
        
        let expectatxn = expectation(description: "bla")
        
        mockInputViewController.completionHandler = {
            expectatxn.fulfill()
        }
        
        mockInputViewController.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        let item = mockInputViewController.itemManager?.itemAtIndex(index: 0)
        let testItem = ToDoItem(title: "Test Title",
                                itemDescription: "Test Description",
                                timestamp: 1456095600,
                                location: Location(name: "Office", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
    }

    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actions(
                forTarget: sut,
                forControlEvent: .touchUpInside
        ) else {
                XCTFail()
                return
        }

        XCTAssertTrue(actions.contains("save"))
    }

    func test_GeocoderWorksAsExpected() {
        let expectationXC = expectation(description: "Wait for geocode")

        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertin") { (placemarks, error) -> Void in
            let placemark = placemarks?.first

            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }

            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }

            XCTAssertEqual(
                latitude,
                37.3316851,
                accuracy: 0.000001
            )

            XCTAssertEqual(
                longitude,
                -122.0300674,
                accuracy: 0.000001
            )

            expectationXC.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
//        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save()

        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }

}


extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(
            _ addressString: String,
            completionHandler: @escaping CLGeocodeCompletionHandler
        ) {
            
            self.completionHandler = completionHandler
        }
    }

    class MockPlacemark : CLPlacemark {

        var mockCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            
            return CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        }
    }
    
    class MockInputViewController : InputViewController {
        
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?
        
        override func dismiss(animated flag: Bool,
            completion: (() -> Void)?) {
                
                dismissGotCalled = true
                completionHandler?()
        }
    }

}
