//
//  MapPresenter.swift
//  Public Transport
//
//  Created by Diana Princess on 26.02.2022.
//

import Foundation
import MapboxMaps

protocol MapViewProtocol: class {
    func setupButton()
    func createMap(stationResponse: StationResponseModel, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    func failure(error: Error)
    func showError(message: String)
    func handleShowBottomSheet(stationResponse: StationResponseModel)
}

protocol MapPresenterProtocol: class {
    init(view: MapViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, id: String)
    func requestStation(id: String)
    func updateStation(id: String)
}

class MapPresenter: MapPresenterProtocol {
    weak var view: MapViewProtocol?
    let networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var content : [StationCellContent] = [StationCellContent]()
    var response: StationResponseModel?
    var id: String?
    required init(view: MapViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, id: String) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.id = id
        requestStation(id: id)
    }
    
    func requestStation(id: String) {
        networkService.getOneStation(id: id){ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                    if response?.code == 0 {
                        self.view?.showError(message: response?.message ?? "Internal Server Error")
                    }
                    else {
                        self.view?.createMap(stationResponse: response!, latitude: response?.lat ?? 55.75148, longitude: response?.lon ?? 37.61778)
                    }
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func updateStation(id: String) {
        networkService.getOneStation(id: id){ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                    self.view?.handleShowBottomSheet(stationResponse: response!)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
