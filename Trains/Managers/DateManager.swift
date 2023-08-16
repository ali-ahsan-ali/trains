//
//  DateManager.swift
//  Trains
//
//  Created by Ali, Ali on 15/8/2023.
//

import Foundation

class DateManager {
    static var shared = {
        Date().addingTimeInterval(TimeInterval(-1))
    }
}
