//
//  CustomerMV.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/12/22.
//

import Foundation
import Combine
import SwiftLocation

class CustomerMV : ObservableObject {
    
    @Published var customers: [CustomerModel] = []
    @Published var messageError : String = ""
    private let dataService : CustomerService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText : String =  ""
    
    private var typeCustomer = ""
    
    init(typeCustomer: String) {
        dataService  = CustomerService(typeCustomer: typeCustomer)
        addSubcribers()
    }
    
    func addSubcribers() {
 
        $searchText
            .combineLatest(dataService.$allCustomers)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterCust)
            .sink { [weak self] (returncust) in
                self?.customers = returncust
            }
            .store(in: &cancellables)
    }
    private func filterCust(text : String, customers: [CustomerModel]) -> [CustomerModel] {
        guard !text.isEmpty else {
            return customers
        }
        let lowercasedText = text.lowercased()
       return customers.filter { (cust) -> Bool in
            return cust.NAME != nil ? (cust.NAME!.lowercased().contains(lowercasedText)) : false ||
                      cust.CLIENT_ID.lowercased().contains(lowercasedText)
        }
    }
    
    

    func getCustomerFiltered(query : String) -> [CustomerModel] {
        
        let sortedCustomer =  customers.sorted {
            return $0.NAME ?? "" > $1.NAME ?? ""
        }
        if query ==  "" {
            return sortedCustomer
        }
        
        return sortedCustomer.filter {
            ($0.NAME != nil ?  ($0.NAME!.lowercased().contains(query.lowercased())) : false)
            || ($0.CLIENT_ID.lowercased().contains(query.lowercased()))
            
        }
    }
    

    
    
    
}
