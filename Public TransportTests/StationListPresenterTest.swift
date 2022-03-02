//
//  StationListPresenterTest.swift
//  Public TransportTests
//
//  Created by Diana Princess on 25.02.2022.
//

import XCTest
@testable import Public_Transport

class StationListMockView: StationListViewProtocol {
    
    func requestSuccess() {
    }
    
    func requestFailure(error: Error) {
    }
    
}

class MockNetworkService: NetworkServiceProtocol {
    var response: StationListResponseModel!
    
    init() {}
    convenience init(response: StationListResponseModel) {
        self.init()
        self.response = response
    }
    func getStations(completion: @escaping (Result<StationListResponseModel?, Error>) -> Void) {
        if let response = response {
            completion(.success(response))
        } else {
            let error = NSError(domain: "bar", code: 1, userInfo: nil)
            completion(.failure(error))
        }
    }
    
    func getOneStation(id: String, completion: @escaping (Result<StationResponseModel?, Error>) -> Void) {
    }
}

class StationListPresenterTest: XCTestCase {

    var view: StationListMockView!
    var presenter: StationListPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var response = StationListResponseModel(data: [])
    
    override func setUpWithError() throws {
        let nav = UINavigationController()
        let builder = ModuleBuilder()
        router = Router(navigationController: nav, moduleBuilder: builder)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        view = nil
        presenter = nil
        networkService = nil
    }

    func testGetStations(){
        let station = Station(id: "Foo", lat: 12.345678, lon: 12.345678, name: "FooBazBar", type: "Baz", shareUrl: "Bar", wifi: false, usb: false, transportTypes: ["baz"], isFavorite: false, cityShuttle: false, electrobus: false)
        let secondStation = Station(id: "Baz", lat: 98.765432, lon: 98.765432, name: "BazBarFoo", type: "Bar", shareUrl: "Foo", wifi: false, usb: false, transportTypes: ["bar"], isFavorite: false, cityShuttle: false, electrobus: false)
        let thirdStation = Station(id: "Bar", lat: 23.456789, lon: 23.456789, name: "BarFooBaz", type: "Foo", shareUrl: "Baz", wifi: false, usb: false, transportTypes: ["foo"], isFavorite: false, cityShuttle: false, electrobus: false)
        response.data.append(station)
        response.data.append(secondStation)
        response.data.append(thirdStation)
        
        view = StationListMockView()
        networkService = MockNetworkService(response: response)
        presenter = StationListPresenter(view: view, networkService: networkService, router: router)
        
        var catchStations: StationListResponseModel?
        
        networkService.getStations{ result in
            switch result {
            case .success(let response):
                catchStations = response
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        XCTAssertNotEqual(catchStations?.data.count, 0)
        XCTAssertEqual(catchStations?.data.count, response.data.count)
    }
    
    func testFailures(){
        let station = Station(id: "Foo", lat: 12.345678, lon: 12.345678, name: "FooBazBar", type: "Baz", shareUrl: "Bar", wifi: false, usb: false, transportTypes: ["baz"], isFavorite: false, cityShuttle: false, electrobus: false)
        let secondStation = Station(id: "Baz", lat: 98.765432, lon: 98.765432, name: "BazBarFoo", type: "Bar", shareUrl: "Foo", wifi: false, usb: false, transportTypes: ["bar"], isFavorite: false, cityShuttle: false, electrobus: false)
        let thirdStation = Station(id: "Bar", lat: 23.456789, lon: 23.456789, name: "BarFooBaz", type: "Foo", shareUrl: "Baz", wifi: false, usb: false, transportTypes: ["foo"], isFavorite: false, cityShuttle: false, electrobus: false)
        response.data.append(station)
        response.data.append(secondStation)
        response.data.append(thirdStation)
        
        view = StationListMockView()
        networkService = MockNetworkService()
        presenter = StationListPresenter(view: view, networkService: networkService, router: router)
        
        var catchError: Error?
        
        networkService.getStations{ result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                catchError = error
            }
        }
        
        
        XCTAssertNotNil(catchError)
    }

}
