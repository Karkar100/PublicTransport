//
//  ModuleBuilder.swift
//  Public Transport
//
//  Created by Kirill Mordashov on 25.02.2022.
//

import Foundation
import UIKit

protocol ModuleBuilderProtocol {
    func buildStationList(router: RouterProtocol) -> UIViewController
    func buildMap(id: String, router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    func buildStationList(router: RouterProtocol) -> UIViewController {
        let view = StationListViewController()
        let networkService = NetworkService()
        let presenter = StationListPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    func buildMap(id: String, router: RouterProtocol) -> UIViewController {
        let view = MapViewController()
        let networkService = NetworkService()
        let presenter = MapPresenter(view: view, networkService: networkService, router: router, id: id)
        view.presenter = presenter
        return view
    }
}
