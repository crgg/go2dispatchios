//
//  DriverViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/10/22.
//

import Foundation


class DriverViewModel : ObservableObject {
    
    @Published var driver_list = [DriverTripModel]()
    
    func getDrivers() {
        driver_list = DriverTripModel.sample
    }
    
    
    func getStoredFiltered(query : String) -> [DriverTripModel] {
        let sortedDriver = driver_list.sorted {
            return $0.DRIVER_ID > $1.DRIVER_ID
        }
        if query == "" {
            return sortedDriver
        }
        
        return sortedDriver.filter {
            ($0.DRIVER_ID.lowercased().contains(query.lowercased()))
            || ($0.DEFAULT_PUNIT != nil ? ($0.DEFAULT_PUNIT!.lowercased().contains(query.lowercased())) : false)
            || ($0.NAME.lowercased().contains(query.lowercased()))
            
        }
    }
    
    
}
