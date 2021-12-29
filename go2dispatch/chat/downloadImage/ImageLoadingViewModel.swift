//
//  ImageLoadingViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/27/21.
//

import Foundation
import SwiftUI
import UIKit
import Combine

class ImageLoadingViewModel : ObservableObject {
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    
    let manager =  PhotoModelFileManager.instance
    let urlString : String
    let imageKey : String
    
    var cancellables =  Set<AnyCancellable>()
    
    init(url : String, key : String) {
        urlString = url
        imageKey = key
        getImage()
    }
    
    func getImage() {
        if let saveImage = manager.get(key: imageKey) {
            image = saveImage
            print("Getting save image")
        } else {
            downloadImage()
            print("Download imge !!!")
        }
    }
    
    func downloadImage() {
        print("Downloading image now!!!")
        isLoading = true
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let image = returnedImage else { return }
                
                self.image = image
                self.manager.add(key: self.imageKey, value: image)
            }
            .store(in: &cancellables)
    }
    
}
    
