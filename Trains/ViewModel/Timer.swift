//
//  Timer.swift
//  Trains
//
//  Created by Ali Ali on 16/2/2024.
//

import Foundation
import Combine

class MyTimer {
    let currentTimePublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
    let cancellable: AnyCancellable?

    init() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
    }

    deinit {
        self.cancellable?.cancel()
    }
}
