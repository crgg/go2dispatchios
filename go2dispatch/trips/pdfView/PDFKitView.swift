//
//  PDFKitView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/7/22.
//

import SwiftUI

struct PDFKitView: View {
    
    @StateObject var loader : PdfViewModel
    
//    var url: URL
    init(url: String, key: String) {
        _loader = StateObject(wrappedValue: PdfViewModel(url: url, key: key))
    }
    
    
    
    var body: some View {
        VStack {
            if loader.isLoading {
                ProgressView()
            } else if let pdfdoc = loader.pdfFile {
                PDFKitRepresentedView(pdfdoc: pdfdoc)
            }
        }
    }
}

struct PDFKitView_Previews: PreviewProvider {
    static var previews: some View {
        PDFKitView(url: TripList.sampleTrips[0].freights[0].fotos[0].avatar, key: String(TripList.sampleTrips[0].freights[0].fotos[0].id))
    }
}

 
