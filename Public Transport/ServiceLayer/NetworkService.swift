//
//  NetworkService.swift
//  Public Transport
//
//  Created by Diana Princess on 25.02.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getStations(completion: @escaping(Result<StationListResponseModel?, Error>) -> Void)
    func getOneStation(id: String, completion: @escaping(Result<StationResponseModel?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getStations(completion: @escaping (Result<StationListResponseModel?, Error>) -> Void) {
        let urlString = "https://api.mosgorpass.ru/v8.2/stop"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url){ data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let response: StationListResponseModel = try! JSONDecoder().decode(StationListResponseModel.self, from: data!)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getOneStation(id: String, completion: @escaping (Result<StationResponseModel?, Error>) -> Void) {
        var stationString = "https://api.mosgorpass.ru/v8.2/stop/"+id
        guard let url = URL(string: stationString) else {return}
        URLSession.shared.dataTask(with: url){ data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let response: StationResponseModel = try! JSONDecoder().decode(StationResponseModel.self, from: data!)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
