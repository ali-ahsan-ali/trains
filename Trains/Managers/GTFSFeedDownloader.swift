//
//  TrainManager.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

//"https://api.transport.nsw.gov.au/v1/gtfs/schedule/sydneytrains"

import Alamofire
import Foundation
import SSZipArchive

class GTFSManager {
    static let downloadLocation = FileManager.default.temporaryDirectory.appendingPathComponent("sydneytrains.zip")
    static let feedLocation = FileManager.default.temporaryDirectory.appendingPathComponent("feed.json")
    func retrieve(url: String) async -> Feed? {
        guard let url = URL(string: url) else { return nil }
        do {
            if FileManager.default.fileExists(atPath: GTFSManager.downloadLocation.path){
                let data = try await makeZipFileApiCall(fromURL: url)
                let file = try saveDataAsZIPAndReturnUnzippedFile(data: data, destinationURL: GTFSManager.downloadLocation)
                let cleanData = parseFeed(fromDirectory: file)
                return cleanData
            } else{
                let cleanData = parseFeed(fromDirectory: FileManager.default.temporaryDirectory)
                return cleanData
            }
        } catch{
            return nil
        }
    }
    
    // Function to download GTFS data from a ZIP file
    func makeZipFileApiCall(fromURL url: URL) async throws -> Data {
        let headers: HTTPHeaders = [
            "Accept": "application/zip",
            "Authorization": "apikey 7gJ5ClWmlCngb7nmj4jnZRlhXCYjj8nDmeAg"
        ]
        let request = AF.request(url, headers: headers)

        return try await withCheckedThrowingContinuation { continuation in
            request.responseData { response in
                if let httpResponse = response.response, httpResponse.statusCode == 200 {
                    if let data = response.data {
                        continuation.resume(returning: data)
                        return
                    } else {
                        let error = NSError(domain: "CustomErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get data"])
                        continuation.resume(throwing: error)
                        return
                    }
                } else {
                    if let error = response.error {
                        continuation.resume(throwing: error)
                        return
                    }
                    else if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                        let error = NSError(domain: "CustomErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
                        continuation.resume(throwing: error)
                        return
                    }  else {
                        let error = NSError(domain: "CustomErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func saveDataAsZIPAndReturnUnzippedFile(data: Data, destinationURL: URL) throws -> URL{
        try data.write(to: destinationURL)
        
        let unzipDirectory = destinationURL.deletingLastPathComponent()
        
        let success = SSZipArchive.unzipFile(atPath: destinationURL.path, toDestination: unzipDirectory.path)
        
        if !success {
            throw NSError(domain: "CustomErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to unzip the file"])
        }
        return unzipDirectory
    }
    
    // Function to parse GTFS data from extracted files
    func parseFeed(fromDirectory directory: URL =  FileManager.default.temporaryDirectory) -> Feed {
        let feed = Feed(contentsOfURL: FileManager.default.temporaryDirectory)
        saveDataAsJson(feed: feed)
        return feed
    }
    
    func saveDataAsJson(feed: Feed, fileLocationToSave: URL = GTFSManager.feedLocation){
        do {
            let jsonData = try JSONEncoder().encode(feed)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let fileURL = GTFSManager.feedLocation// URL to the file where you want to save the JSON data
                do {
                    try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                    // JSON data saved successfully
                } catch {
                    // Error occurred while writing JSON data to file
                    print("Failed to save JSON data:", error)
                }
            } else {
                // Failed to convert JSON data to string
                print("Failed to convert JSON data to string")
            }
        } catch {
            // Error occurred while encoding data object as JSON
            print("Failed to encode data object as JSON:", error)
        }
    }
    
}

