//
//  PdfViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/7/22.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import PDFKit

class PdfViewModel : ObservableObject {
    @Published var pdfFile : PDFDocument? = nil
    @Published var isLoading : Bool = false
    
    let manager =  FilePdfFileManager.instance
    let urlString : String
    let pdfkey : String
    
    var cancellables = Set<AnyCancellable>()
    
    init(url: String , key: String) {
        self.urlString = url
        self.pdfkey =  key
        getPdfFile()
    }
    func getPdfFile() {
//        if let savePdfFile = manager.get(key: pdfkey) {
//
//        }
//
        downloadPdf()
    }
    
    func downloadPdf() {
        print("download pdf now !!!")
        
        guard let url = URL(string: urlString)
        else {
             isLoading = false
            print("no reconoce la url")
            return
        }
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map({ PDFDocument(data: $0.data)  })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.isLoading  = false
            } receiveValue : { [weak self] (returnFile) in
                guard let self = self, let fileR =
                        returnFile else { return}
                
                self.pdfFile? = fileR
                
                
            }
            .store(in: &cancellables)
                
            
        
    }
    
    
    
}
