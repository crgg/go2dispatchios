//
//  TripListViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation
class TripListViewModel : ObservableObject {
    @Published var tripsList = [TripList]()
    
    
    func getTrips() {
        tripsList = TripList.sampleTrips
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
