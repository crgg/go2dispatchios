//
//  ChatAllUserViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/27/21.
//

import Foundation
import Combine
class ChatAllUserViewModel : ObservableObject {
    
    @Published var dataArray = [driver_users]()
    
    let dataService = ChatAllUserService.instance
    var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$chatAllUsers
            .sink { [weak self] (returnAllDriverUsers) in
                    self?.dataArray = returnAllDriverUsers
            }
            .store(in: &cancellables)
    }
    
    func getSortedFilteredChatsAllDrivers(query : String) -> [driver_users] {
        let sortedChats = dataArray.sorted {
            return $0.name < $1.name
        }
        if query == "" {
            return sortedChats
        }
        return sortedChats.filter { $0.driverID.lowercased().contains(query.lowercased())
                                      || $0.name.lowercased().contains(query.lowercased())
            
        }
        
        
    }
    
    
}
