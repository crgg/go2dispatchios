//
//  apiCustomer.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/12/22.
//

import Foundation
import Combine


class CustomerService : ObservableObject {
    
    @Published var allCustomers : [CustomerModel] = []
    var cancellables =  Set<AnyCancellable>()
    
    
    var customerSubcription: AnyCancellable?
    
    init() {
        
        
    }
    init(typeCustomer : String) {
        get(client_type: typeCustomer)
        
    }
    
    
 
    func get(client_type : String) {
        
        guard let url = URL(string: ApiConfig.RETURN_SEARCH_LIST) else {
            return
        }
       
        let param = ["client_type" : client_type ]
        
        guard let jsonParam = try? JSONEncoder().encode(param) else {
            print("error the parameters")
        
            return
        }
                
        customerSubcription =  NetWorkingManager.donwload(url: url, jsonParam: jsonParam, method: .POST)
            .decode(type: customerReceived.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetWorkingManager.handleCompletion , receiveValue: { [weak self] (customerReceived) in 
                self?.customerSubcription?.cancel()
                self?.allCustomers =  customerReceived.data
            })
        
 
    }
    
    
}
