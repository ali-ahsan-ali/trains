//
//  NetworkManager.swift
//  Trains
//
//  Created by Ali, Ali on 15/8/2023.
//

import Foundation
import Alamofire

class Network {
    static let session: Session = {
        let manager = ServerTrustManager(evaluators: ["prisma2.cba": DisabledTrustEvaluator(), "api.transport.nsw.gov.au": DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
}
