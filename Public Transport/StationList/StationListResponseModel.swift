//
//  StationListData.swift
//  Public Transport
//
//  Created by Kirill Mordashov on 25.02.2022.
//

import Foundation

struct StationListResponseModel: Codable {
    var data: Array<Station>
}
struct Station: Codable{
    var id: String
    var lat: Double
    var lon: Double
    var name: String
    var type: String
    var shareUrl: String
    var wifi: Bool
    var usb: Bool
    var transportTypes: Array<String>
    var isFavorite: Bool
    var cityShuttle: Bool
    var electrobus: Bool
}
