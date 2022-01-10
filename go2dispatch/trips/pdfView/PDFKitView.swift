//
//  PDFKitView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/7/22.
//

import SwiftUI

struct PDFKitView: View {
    var url: URL
    
    var body: some View {
        PDFKitRepresentedView(url: url)
    }
}

 
