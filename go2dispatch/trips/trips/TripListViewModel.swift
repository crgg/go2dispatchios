//
//  TripListViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation
import Combine
import SwiftUI


enum TypeDeassign {
    
    case trailer(trip: TripList)
    case driver(trip : TripList)
    case truck(trip : TripList)
    case equip(trip : TripList)
    
}

class TripListViewModel : ObservableObject {
    @Published var tripsList = [TripList]()
    private var cancellables = Set<AnyCancellable>()
    @Published var currentFotos : [fotos] = []
    @Published var currentFreight : Freight =  TripList.sampleTrips[0].freights[0]
    @Published var typeDeassign : TypeDeassign?
    
    private let tripServices  = TripServices()
    
    init() {
        
        addObservable()
        tripServices.get("NLTERM")
    }
    
    public func updateTrip(trip: TripList) {
        let t = tripsList.map{ $0.trip_number == trip.trip_number ? trip : $0   }
        self.tripsList = t
    }
    
    private func addObservable() {
        tripServices.$allTrips
            .map { (trips ) -> [TripList]  in
                return trips
            }
            .sink {
                [weak self ] (returndata) in
                self?.tripsList = returndata
                
            }
            .store(in: &cancellables)
            
    }
    
    func setCurrentFreight(_ freight: Freight) {
        self.currentFreight =  freight
    }
    
    func getCurrentFreight() -> Freight {
        return  self.currentFreight 
    }
    
    func setCurrentDocument(_ foto: [fotos]) {
        currentFotos =  foto.filter { $0.typedocument == "D" }
    }
    
    func getCurrentDocuments() -> [fotos] {
        return  currentFotos.filter { $0.typedocument == "D" }
    }
    
    func setCurrentFotos(_ foto : [fotos]) {
        currentFotos =  foto.filter { $0.typedocument == "F" }
    }
    
    func getCurrentFotos() -> [fotos] {
        return currentFotos.filter { $0.typedocument == "F" }
    }
    
    func explanded(_ id : Int, expland : Bool) {
        if let row = self.tripsList.firstIndex(where: {$0.trip_number == id}) {
            self.tripsList[row].expland = expland
        }
    
    }
    
    func checkDocument(photos: [fotos], typeDoc : String) -> Bool {
        return (photos.first(where : { $0.typedocument == typeDoc }) != nil)
    }
    
    func getTrips()  {
        tripsList = TripList.sampleTrips
    }
    
    func deassign() {
        switch self.typeDeassign {
        case .trailer(trip: let trip1):
            print("deassign trailer")
        case .none:
            print("none")
        case .some(.driver(trip: let trip)):
            print("deassing driver")
        case .some(.truck(trip: let trip)):
            print("deassing truck")
        case .some(.equip(trip: let trip)):
            print("deassing equip")
        }
        
    }
    
    func deassignType() -> String {
        switch self.typeDeassign {
        case .trailer(trip: let trip):
            return "Trailer \(trip.trailer_id ?? "") of \(String(trip.trip_number))"
        case .none:
            return ""
        case .some(.driver(trip: let trip)):
            return "Driver \(trip.driver_id ?? "")"
        case .some(.truck(trip: let trip)):
            return "Truck \(trip.trailer_id ?? "")"
        case .some(.equip(trip: _)):
            return "equip"
        }
    }
    
    
    func getSortedFiltered(query : String) -> [TripList] {
        let sortedTrips = tripsList.sorted {
            return $0.trip_number > $1.trip_number
        }
        if query == "" {
            return sortedTrips
        }
        return sortedTrips.filter {
            ($0.truck_id != nil ? ($0.truck_id!.lowercased().contains(query.lowercased())) : false)
            || ($0.trailer_id != nil ? ($0.trailer_id!.lowercased().contains(query.lowercased())) : false)
            || (String($0.trip_number).starts(with: query))
            
        }
    }
}
