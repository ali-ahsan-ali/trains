//
//  Station.swift
//  Trains
//
//  Created by Ali, Ali on 5/8/2023.
//

import Foundation

struct Station: Identifiable, Codable {
    let id: String
    let name: String
    let lon: Double?
    let lat: Double?
    let platforms: [Stop]
}
