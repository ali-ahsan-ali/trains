//
//  Double+Extensions.swift
//  Trains
//
//  Created by Ali Ali on 10/2/2024.
//

import Foundation

extension Double {
    static func from(_ string: String?) -> Double? {
        if let string = string {
            return Double(string)
        } else {
            return nil
        }
    }
}
