//
//  PDFKitView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/7/22.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFKitRepresentedView : UIViewRepresentable {
    
    var url : URL?
    
    func makeUIView(context: Context) -> UIView {
        let pdfView = PDFView()
        
        
        pdfView.autoresizesSubviews = true
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
        pdfView.displayDirection = .vertical
        
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displaysPageBreaks = true
        
        
   
        
        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }
        return pdfView
        
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
