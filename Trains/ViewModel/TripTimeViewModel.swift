//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import OpenTripPlannerApi
import SwiftUI
import Apollo

class TripTimeViewModel: ObservableObject {
    init(tripViewModel: TripViewModel, tripTimes: [Plan] = [], appAlert: String? = nil, isError: Bool = false) {
        self.tripViewModel = tripViewModel
        self.tripTimes = tripTimes
        self.appAlert = appAlert
        self.isError = isError
    }
    
    enum stopRelationShip {
        case stationToStop
        case stopToStation
        case platformToPlatform
        case none
    }
    
    let tripViewModel: TripViewModel
    @Published var tripTimes: [Plan]
    @Published var appAlert: String?
    @Published var isError: Bool
    @Published var watcher: GraphQLQueryWatcher<TripPlannerQuery>?
    
    func createWatcher() {
        let query = TripPlannerQuery(fromPlace: GraphQLNullable(stringLiteral: fromStationQueryInput), toPlace: GraphQLNullable(stringLiteral: toStationQueryInput), numItineraries: GraphQLNullable(integerLiteral: 10), searchWindow: GraphQLNullable(stringLiteral: "3600"))
        self.watcher = Network.shared.apolloClient?.watch(query: query, cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                guard let plan = graphQLResult.data?.plan else {
                    self.appAlert = "ERROR"
                    self.isError = true
                    return
                }
                if !plan.routingErrors.isEmpty {
                    self.appAlert = "ERROR"
                    self.isError = true
                } else if !plan.itineraries.isEmpty {
                    self.tripTimes = mapPlans(itineraries: plan.itineraries)
                    self.appAlert = ""
                    self.isError = false
                } else {
                    self.appAlert = "ERROR"
                    self.isError = true
                }
                if let errors = graphQLResult.errors {
                    self.appAlert = errors.debugDescription
                    self.isError = true
                }
            case .failure(let error):
                self.appAlert = error.localizedDescription
                self.isError = true
            }
        }
    }
    
    private var fromStationQueryInput: String {
        guard let lat = tripViewModel.fromStation.lat, let lon = tripViewModel.fromStation.lon else {
            self.appAlert = "ERROR"
            self.isError = true
            return ""
        }
        return "\(tripViewModel.fromStation.name)::\(lat),\(lon)"
    }
    
    private var toStationQueryInput: String {
        guard let lat = tripViewModel.toStation.lat, let lon = tripViewModel.toStation.lon else {
            self.appAlert = "ERROR"
            self.isError = true
            return ""
        }
        return "\(tripViewModel.toStation.name)::\(lat),\(lon)"
    }
    
    func stationStopRelationship(from: TripPlannerQuery.Data.Plan.Itinerary.Leg.From, to: TripPlannerQuery.Data.Plan.Itinerary.Leg.To) -> stopRelationShip {
        guard let fromName = from.name, let toName = to.name else { return .none }
        // If from parent station to child stop
        if fromName == tripViewModel.fromStation.name, tripViewModel.fromStation.platforms.contains(where: { $0.name == toName }) {
            return .stationToStop
        }
        // If from child stop to parent station
        if from.stop?.parentStation?.id == tripViewModel.toStation.id {
            return .stopToStation
        }
        // Move between platforms
        if from.stop?.parentStation?.id == to.stop?.parentStation?.id, from.stop?.parentStation?.id != nil {
            return .platformToPlatform
        }
        return .none
    }
    
    func modeConverter(mode: GraphQLEnum<OpenTripPlannerApi.Mode>?) -> Mode {
        guard let mode = mode?.value else { return Mode.unknown }
        switch mode {
        case OpenTripPlannerApi.Mode.rail:
            return Mode.rail
        case OpenTripPlannerApi.Mode.walk:
            return Mode.walk
        default:
            return Mode.unknown
        }
    }
    
    func mapPlans(itineraries: [TripPlannerQuery.Data.Plan.Itinerary?]) -> [Plan] {
        var plans: [Plan] = []
        let itinerariesUnwrapped: [TripPlannerQuery.Data.Plan.Itinerary] = itineraries.compactMap { $0 }
        itinerariesUnwrapped.forEach { itinerary in
            let plan = Plan(
                startTime: Date(unixTime: itinerary.startTime),
                endTime: Date(unixTime: itinerary.endTime),
                duration: TimeInterval(Long(itinerary.duration ?? "0")) ?? -1
            )
            for leg in itinerary.legs {
                guard let from = leg?.from, let to = leg?.to else { continue }
                // If leg is between station and child stop
                // or child stop and parent station, remove the leg
                switch self.stationStopRelationship(from: from, to: to) {
                case.stationToStop:
                    continue
                case .stopToStation:
                    // Moving from stop to station, signifying end of trip
                    plan.legs.last?.to = Stop(id: to.stop?.id ?? "", name: to.name ?? "No Name")
                    if let endTime = plan.legs.last?.endTime {
                        plan.endTime = endTime
                    }
                    continue
                case .platformToPlatform:
                    continue
                default:
                    break
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_AU")
                guard leg?.transitLeg == true, let legServiceDate = leg?.serviceDate, let serviceDate = dateFormatter.date(from: legServiceDate) else {
                    self.appAlert = "ERROR"
                    self.isError = true
                    continue
                }
                
                // If you can continue on the same train, edit previous leg with info and continue
                if leg?.interlineWithPreviousLeg == true {
                    
                    guard let endTime = leg?.endTime, let lastLeg = plan.legs.last, let duration = itinerary.duration, let durationInterval = TimeInterval(Long(duration)) else {
                        return
                    }
                    lastLeg.endTime = Date(unixTime: endTime)
                    lastLeg.duration += durationInterval
                    lastLeg.to = Stop(id: to.stop?.id ?? "", name: to.name ?? "No Name")
                    // Add from as a intermediate stop of last trip
                    if let from = leg?.from, let fromStop = from.stop,
                       let stopTime = leg?.trip?.stoptimes?.first(where: { $0?.stop?.id == from.stop?.id }),
                       let arrival = stopTime?.realtimeArrival, let departure = stopTime?.realtimeDeparture {
                        let arrivalDate = turnSecondsFromServiceDayMightnightToDate(arrival, serviceDate)
                        let departureDate = turnSecondsFromServiceDayMightnightToDate(departure, serviceDate)
                        lastLeg.intermediaryStops.append(
                            StopTimes(stop: Stop(id: fromStop.id, name: fromStop.name), arrival: arrivalDate, departure: departureDate)
                        )
                    }
                    // Add all intemediary stops of the new leg
                    lastLeg.intermediaryStops.append(contentsOf: leg?.intermediateStops?.compactMap { stop in
                        if let stop, let stopTime = leg?.trip?.stoptimes?.first(where: { $0?.stop?.id == stop.id }),
                           let arrival = stopTime?.realtimeArrival, let departure = stopTime?.realtimeDeparture {
                            let arrivalDate = turnSecondsFromServiceDayMightnightToDate(arrival, serviceDate)
                            let departureDate = turnSecondsFromServiceDayMightnightToDate(departure, serviceDate)
                            return StopTimes(stop: Stop(id: stop.id, name: stop.name), arrival: arrivalDate, departure: departureDate)
                        }
                        return nil
                    } ?? [])
                    continue
                }
                guard let startTime = leg?.startTime, let endTime = leg?.endTime,
                      let fromStop = from.stop, let toStop = to.stop,
                        let duration = itinerary.duration, let durationInterval = TimeInterval(Long(duration)) else {
                    return
                }

                plan.legs.append(
                    Leg(
                        startTime: Date(unixTime: startTime),
                        endTime: Date(unixTime: endTime),
                        duration: durationInterval,
                        from: Stop(id: fromStop.id, name: fromStop.name),
                        to: Stop(id: toStop.id, name: toStop.name),
                        intermediaryStops: leg?.intermediateStops?.compactMap { stop in
                            if let stop, let stopTime = leg?.trip?.stoptimes?.first(where: { $0?.stop?.id == stop.id }),
                                let arrival = stopTime?.realtimeArrival, let departure = stopTime?.realtimeDeparture {
                                let arrivalDate = turnSecondsFromServiceDayMightnightToDate(arrival, serviceDate)
                                let departureDate = turnSecondsFromServiceDayMightnightToDate(departure, serviceDate)
                                return StopTimes(stop: Stop(id: stop.id, name: stop.name), arrival: arrivalDate, departure: departureDate)
                            }
                            return nil
                        } ?? [],
                        mode: modeConverter(mode: leg?.mode)
                    )
                )
            }
            plans.append(plan)
        }
        return plans
    }
    
    func turnSecondsFromServiceDayMightnightToDate(_ secondsFromMidnight: Int, _ serviceDate: Date) -> Date {
        return serviceDate.addingTimeInterval(TimeInterval(secondsFromMidnight))
    }
}

extension Date {
    init(unixTime: Long?) {
        if let unixTime, let interval = TimeInterval(Long(unixTime)) {
            self = Date(timeIntervalSince1970: interval / 1000)
        } else {
            self = Date()
        }
    }
}
