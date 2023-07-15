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
    static let stopTimesLocation = FileManager.default.temporaryDirectory.appendingPathComponent("stop_times.txt")

    func setUpApp(stops: Stops) async {
        do {
            _ = try unzipFile(destinationURL: GTFSManager.downloadLocation)
//            let trips1 = try Trips(from: FileManager.default.temporaryDirectory.appendingPathComponent("trips.txt"))
//            var tripDict: [String:Trip] = [:]
//            for trip in trips1.trips {
//                tripDict[trip.tripID] = trip
//            }
//            saveDataAsJson(data: tripDict, fileLocationToSave: FileManager.default.temporaryDirectory.appendingPathComponent("trips.json"))
//
//            let calendar = try GTFSCalendar(from: FileManager.default.temporaryDirectory.appendingPathComponent("calendar.txt"))
//            var calDict: [String:CalendarRow] = [:]
//            for cal in calendar.serviceAvailability {
//                calDict[cal.service_id] = cal
//            }
//            saveDataAsJson(data: calDict, fileLocationToSave: FileManager.default.temporaryDirectory.appendingPathComponent("calendar.json"))
            let trips = try parseTrips()
            let cal = try parseCal()
            var stopTimes: StopTimes? = try StopTimes(from: FileManager.default.temporaryDirectory.appendingPathComponent("stop_times.txt"))
            var dict: [String:[StopTime]] = [:]
            for stopTime in stopTimes! {
                var stopTimes: [StopTime] = []
                if let serviceID = trips[stopTime.tripID]?.serviceID,
                   let calRow = cal[serviceID] {
                    for dayOfWeek in calRow.weekDays{
                        var copy = stopTime
                        if let hour = copy.arrival?.hour, copy.arrival?.weekday != nil, hour >= 24 {
                            copy.arrival?.weekday! = (dayOfWeek + 1) % 7
                            copy.departure?.weekday! = (dayOfWeek + 1) % 7
                            copy.arrival?.hour! -= 24
                        }else {
                            copy.arrival?.weekday = dayOfWeek
                            copy.departure?.weekday = dayOfWeek
                        }
                        copy.startDate = calRow.start_date
                        copy.endDate = calRow.end_date
                        stopTimes.append(copy)
                    }
                }else {
                    stopTimes = [stopTime]
                }
                
                if dict.keys.contains(stopTime.stopID){
                    dict[stopTime.stopID]?.append(contentsOf: stopTimes)
                }else {
                    dict[stopTime.stopID] = stopTimes
                }
            }
            // for each stop time, for each trip, add a day of the week and the time
            
            
            stopTimes = nil
            for key in dict.keys{
                dict[key] = dict[key]?.sorted{ stopTime1, stopTime2 in
                    let t1 = stopTime1.arrival ?? DateComponents()
                    let t2 = stopTime2.arrival ?? DateComponents()
                    return t1 < t2
                }
                saveDataAsJson(data: dict[key], fileLocationToSave: FileManager.default.temporaryDirectory.appendingPathComponent("stoptimes").appendingPathComponent("stop_times_\(key).json"))
            }
        } catch {
            print(error)
        }
        
    }
    
    func parseStopTimes(stop: Stop) async throws -> [String: [Date]]{
        let date = Calendar.current.date(byAdding: .minute, value: -10, to: Date()) ?? Date()
        var childStopDates: [String: [Date]] = [:]
        for index in stop.childStops.indices {
            if let url = Bundle.main.url(forResource: "stop_times_\(stop.childStops[index].stopID)", withExtension: "json"){
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                var stopTimes = try decoder.decode([StopTime].self, from: data)

                var times: [Date] = []
                stopTimes.forEach { stopTime in
                    guard stopTime.pickupType == 0 || stopTime.pickupType == nil else { return }
                    guard var arrival = stopTime.arrival else {return }
                    arrival.calendar = .current
                    arrival.timeZone = TimeZone(identifier: "Australia/Sydney")
                    guard let nextDate = Calendar.current.nextDate(after: date, matching: arrival, matchingPolicy: .nextTime) else { return }
                    guard nextDate < stopTime.endDate ?? Date.distantFuture && nextDate > stopTime.startDate ?? Date.distantPast else { return }
                    times.append(nextDate)
                }
                times = times.sorted()
                childStopDates[stop.childStops[index].stopID] = times
            }
        }
        return childStopDates
    }
    
    func parseStops(fromDirectory directory: URL =  FileManager.default.temporaryDirectory) async throws -> Stops {
        let url = Bundle.main.url(forResource: "stops", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let stops = try decoder.decode(Stops.self, from: data)
        return stops
//        } else{
//            let url = URL(string: "https://api.transport.nsw.gov.au/v1/gtfs/schedule/sydneytrains")!
//            let data = try await makeZipFileApiCall(fromURL: url)
//            let file = try saveDataAsZIPAndReturnUnzippedFile(data: data, destinationURL: GTFSManager.downloadLocation)
//            let stops = try Stops(from: file.appendingPathComponent("stops.txt"))
//            saveDataAsJson(data: stops, fileLocationToSave: FileManager.default.temporaryDirectory.appendingPathComponent("stops.json"))
//            return stops
//        }
    }
    
    func parseTrips(fromDirectory directory: URL =  FileManager.default.temporaryDirectory) throws -> [String:Trip] {
        let url = Bundle.main.url(forResource: "trips", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let trips = try decoder.decode([String:Trip].self, from: data)
        return trips
    }
    
    func parseCal(fromDirectory directory: URL =  FileManager.default.temporaryDirectory) throws -> [String:CalendarRow] {
        let url = Bundle.main.url(forResource: "calendar", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let cal = try decoder.decode([String:CalendarRow].self, from: data)
        return cal
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
    
    func unzipFile(destinationURL: URL) throws -> URL{
        let unzipDirectory = destinationURL.deletingLastPathComponent()
        let success = SSZipArchive.unzipFile(atPath: destinationURL.path, toDestination: unzipDirectory.path)
        if !success {
            throw NSError(domain: "CustomErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to unzip the file"])
        }
        return unzipDirectory
    }
    
    func saveDataAsJson<T: Codable>(data: T, fileLocationToSave: URL = GTFSManager.feedLocation) {        do {
            let jsonData = try JSONEncoder().encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let fileURL = fileLocationToSave// URL to the file where you want to save the JSON data
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

