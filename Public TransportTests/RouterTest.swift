//
//  RouterTest.swift
//  Public TransportTests
//
//  Created by Diana Princess on 28.02.2022.
//

import XCTest
@testable import Public_Transport

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    let builder = ModuleBuilder()
    
    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, moduleBuilder: builder)
    }

    override func tearDownWithError() throws {
     router = nil
    }

    func testRouter(){
        router.openStation(id: "baz")
        let mapViewController = navigationController.presentedVC
        XCTAssertTrue(mapViewController is /*StationListViewController*/ MapViewController)
    }
}
