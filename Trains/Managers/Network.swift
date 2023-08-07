import Foundation
import ApolloSQLite
import OpenTripPlannerApi
import Apollo
import OSLog

class Network {
    static let shared = Network()

    var apolloClient: ApolloClient?

    init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        ).first! // swiftlint:disable:this force_unwrapping

        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("test_apollo_db.sqlite")

        do {
            let sqliteCache = try SQLiteNormalizedCache(fileURL: sqliteFileURL)
            let store = ApolloStore(cache: sqliteCache)
            let networkTransport = RequestChainNetworkTransport(interceptorProvider: DefaultInterceptorProvider(store: store), endpointURL: URL(string: "http://localhost:8080/otp/routers/default/index/graphql")!) // swiftlint:disable:this force_unwrapping
            self.apolloClient = ApolloClient(networkTransport: networkTransport, store: store)
        } catch {
            Logger.network.error("ERROR")
            self.apolloClient = nil
        }
    }
}
