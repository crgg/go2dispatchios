//
//  ChatAllUserService.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/27/21.
//

import Foundation
import Combine

class ChatAllUserService {
    
    static let instance = ChatAllUserService()
    
    @Published var chatAllUsers :[All_drivers_users] = []
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        downloadData()
    }
    
    func downloadData() {
        
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.URL_DRIVER_LIST_WITH_IMAGES)"
        
        guard  let url = URL(string: urlString) else { return  }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let apiToken = UserDefaults.standard.getApiToken()
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos:.background ))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: AllDriverUsers.self , decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error download data \(error)")
                }
            } receiveValue: { [weak self] (returnAllDriverUsers) in
                self?.chatAllUsers = returnAllDriverUsers.data
            }
            .store(in: &cancellables)
        
    }

    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
        let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data
    }
    
}
