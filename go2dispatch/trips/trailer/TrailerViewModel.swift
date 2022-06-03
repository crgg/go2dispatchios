//
//  TrailerViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/27/22.
//

import Foundation
import Combine
import SwiftUI


 

enum TypeMessage: String {
    
    case error = "Error"
    case warning = "Warring"
    case message = "Message"
    case success = "success"
    
    case nothing = ""
    
}
class TrailerViewModel : ObservableObject {
    
    @Published var trailers = [TrailerModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let trailerService =  TrailerService()
    
    @Published var selectedTrailer : TrailerModel?
    
    @Published var isError : Bool   = false
    
    @Published var serviceMessage : ServiceMessages?
    
    @Published var typeMessage : TypeMessage = .nothing
    
    @Published var messageOut : String = ""
    
    public let trip: TripList
    
    init (trip: TripList) {
        self.trip = trip
        addObservable()
        trailerService.get()
        
    }
    
    private func addObservable() {
        trailerService.$allItem
            .map{ (trailers) -> [TrailerModel] in
                    return trailers
            }
            .sink {
                [weak self] (returndata) in
                self?.trailers = returndata
                
            }            
            .store(in: &cancellables)

        trailerService.$serviceMessages
            .map{ (msgError) -> ServiceMessages in
                return msgError 
            }
            .sink {
                [weak self] (returndata) in
                
                if case .nothing = returndata {
                    return
                }
                self?.isError =  true
                self?.serviceMessage = returndata
                self?.getMsg()
                
            }
            .store(in: &cancellables)
        
        
    }
    
 
    public func getMsg() {
        switch self.serviceMessage {
        case let .msg(msg: msg1):
            self.typeMessage = .message
            self.messageOut = msg1
            
         
        case let .error(msg: msg2):
            self.typeMessage = .error
            self.messageOut = msg2
       
           
        case .warring(msg: let msg):
            self.typeMessage = .warning
            self.messageOut = msg
         
        case .success(trip: _):
           
            self.typeMessage = .success
            self.messageOut = "Assinged Successfully!!!"
        case .nothing:
            self.messageOut = ""
           
            
        case .none:
            self.messageOut = ""
           
            
        }

        
    }
    
    public func get() {
        trailerService.get()
        
    }
    
    func getSortedFiltered(query: String)->[TrailerModel] {
        let sortedDriver = trailers.sorted {
            return $0.trailerID > $1.trailerID
        }
        if query == "" {
            return sortedDriver
        }
        return sortedDriver.filter {
            ($0.trailerID.lowercased().contains(query.lowercased()))
            || ($0.currentTrip != nil ?
                (String($0.currentTrip!).lowercased().contains(query.lowercased())) : false)
            
            }
            
        }
    
     func assignTrailer() {
        
         guard let selectedTrailer = selectedTrailer else {
             return
         }
         trailerService.assignTrailer(trailer: selectedTrailer.trailerID  , trip_number: trip.trip_number, terminal_zone: "NLTERM", warning: false)
    }
    
    func assingTrailerWarning() {
        trailerService.assignTrailer(trailer: selectedTrailer!.trailerID  , trip_number: trip.trip_number, terminal_zone: "NLTERM", warning: true)
        
    }
    
    
   
    
}
