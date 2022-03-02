//
//  StationResponseModel.swift
//  Public Transport
//
//  Created by Diana Princess on 27.02.2022.
//
import MapboxMaps

struct StationResponseModel: Codable{
    var id: String?
    var name: String
    var type: String?
    var wifi: Bool?
    var routePath: Array<Route>?
    var color: String?
    var routeNumber: String?
    var isFavorite: Bool?
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    var cityShuttle: Bool?
    var electrobus: Bool?
    var transportTypes: Array<String>?
    var regional: Bool?
    var message: String?
    var code: Int?
}

struct Route: Codable{
    var id: String
    var routePathId: String
    var type: String
    var number: String
    var timeArrivalSecond: Array<Int>
    var timeArrival: Array<String>
    var lastStopName: String
    var color: String?
    var fontColor: String?
}
