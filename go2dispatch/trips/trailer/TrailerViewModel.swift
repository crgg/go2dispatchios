//
//  TrailerViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/27/22.
//

import Foundation
import Combine
import SwiftUI

class TrailerViewModel : ObservableObject {
    
    @Published var trailers = [TrailerModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let trailerService =  TrailerService()
    
    
    init () {
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
        
    }

    
}
