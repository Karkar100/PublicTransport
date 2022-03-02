//
//  StationListPresenter.swift
//  Public Transport
//
//  Created by Kirill Mordashov on 25.02.2022.
//

import Foundation
import UIKit

protocol StationListViewProtocol: class {
    func requestSuccess()
    func requestFailure(error: Error)
}

protocol StationListPresenterProtocol: class, UITableViewDelegate, UITableViewDataSource {
    init(view: StationListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getStations()
    func openStation(id: String)
    var response: StationListResponseModel?{get set}
}

class StationListPresenter: NSObject, StationListPresenterProtocol {
    
    weak var view: StationListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var content : [StationCellContent] = [StationCellContent]()
    var response: StationListResponseModel?
    var id: String?
    let cellID = "cellID"
    let myArray = ["First","Second","Third"]
    
    required init(view: StationListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        super.init()
        getStations()
    }
    
    func getStations() {
        networkService.getStations{ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                    self.view?.requestSuccess()
                case .failure(let error):
                    self.view?.requestFailure(error: error)
                }
            }
        }
    }
    
    func openStation(id: String) {
        router?.openStation(id: id)
    }
}

extension StationListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        let station = response?.data[indexPath.row]
        cell.textLabel!.text = station?.name
            return cell
    }
}

extension StationListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let id = response?.data[indexPath.row].id ?? "0004014d-d79e-4e7c-a9ad-91753aba9cc4"
        openStation(id: id)
    }
}
