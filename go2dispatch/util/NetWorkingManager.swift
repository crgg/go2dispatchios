//
//  NetWorkingManager.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/17/22.
//

import Foundation
import Combine
import Alamofire

enum Methods : String {
    case POST = "POST"
    case GET  = "GET"
}

enum NetworkingError : LocalizedError {
    case badeURlResponse(url: URL)
    case unknown
    var errorDescription: String? {
        switch self {
        case .badeURlResponse(url : let url) : return "[🔥]  Bad response from URL. \(url)"
        case .unknown:  return  "[⚠️] Unknow error occured"
            
        }
    }
}
 
class NetWorkingManager {
    
    
    static func get(url: URL, method: Methods)-> AnyPublisher<Data, Error> {

        var request = URLRequest(url, apiToken: UserDefaults.standard.getDeviceToken() )
        request.httpMethod = method.rawValue
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try  handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    static func donwload(url: URL, jsonParam : Data, method : Methods ) -> AnyPublisher<Data, Error>  {
        
        var request = URLRequest(url, apiToken: UserDefaults.standard.getApiToken() ?? "")
        
        request.httpMethod = method.rawValue
        
        request.httpBody =  jsonParam
        return  URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url )})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    
    static func handleURLResponse(output : URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        
            guard let httpResponse = output.response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                      throw NetworkingError.badeURlResponse(url: url)
                  }
            return output.data
        
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error) :
            print(error.localizedDescription)
        }
        
    }
  
    
}
