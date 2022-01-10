//
//  TripListViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation
class TripListViewModel : ObservableObject {
    @Published var tripsList = [TripList]()
    
    @Published var currentFotos : [fotos] = []
    @Published var currentFreight : Freight =  TripList.sampleTrips[0].freights[0]
    
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
