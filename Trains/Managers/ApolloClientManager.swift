import Foundation
import ApolloSQLite
import Apollo
import OSLog

class Network {
    static let apolloClient: ApolloClient = {
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        ).first! // swiftlint:disable:this force_unwrapping

        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("test_apollo_db.sqlite")
        let sqliteCache = try? SQLiteNormalizedCache(fileURL: sqliteFileURL)
        let store = ApolloStore(cache: sqliteCache!) // swiftlint:disable:this force_unwrapping
        let networkTransport = RequestChainNetworkTransport(interceptorProvider: DefaultInterceptorProvider(store: store), endpointURL: URL(string: "http://localhost:8080/otp/routers/default/index/graphql")!) // swiftlint:disable:this force_unwrapping
        return ApolloClient(networkTransport: networkTransport, store: store)
    }()
}
