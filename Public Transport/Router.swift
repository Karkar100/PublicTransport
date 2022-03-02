//
//  RouterProtocol.swift
//  Public Transport
//
//  Created by Diana Princess on 28.02.2022.
//

import UIKit

protocol RouterBasic {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: ModuleBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterBasic {
    func initialViewController()
    func openStation(id: String)
    func popToRoot()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var moduleBuilder: ModuleBuilderProtocol?
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    func initialViewController() {
        if let navigationController = navigationController {
            guard let stationListViewController = moduleBuilder?.buildStationList(router: self) else { return }
            navigationController.viewControllers = [stationListViewController]
        }
    }
    
    func openStation(id: String) {
        if let navigationController = navigationController {
            guard let mapViewController = moduleBuilder?.buildMap(id: id, router: self) else { return }
            navigationController.pushViewController(mapViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
