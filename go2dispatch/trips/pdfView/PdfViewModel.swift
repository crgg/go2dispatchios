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

class PdfViewModel : ObservableObject {
    @Published var data : Data? = nil
    @Published var isLoading : Bool = false
    
    let manager =  PhotoModelFileManager.instance
    let urlString : String
    let pdfkey : String
    
    var cancellables = Set<AnyCancellable>()
    
    init(url: String , key: String) {
        self.urlString = url
        self.pdfkey =  key
        getPdfFile()
    }
    func getPdfFile() {
        if let savePdfFile = manager.get(key: pdfkey) {
            
        }
            
        
    }
    
    
}
