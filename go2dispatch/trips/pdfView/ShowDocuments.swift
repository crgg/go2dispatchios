//
//  ShowDocuments.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/7/22.
//

import SwiftUI

struct ShowDocuments: View {
    let documenturl = [ "https://media.goto-logistics.com/TruckmateDownload/DOC/BOL/BOL-555306.pdf",
                       "https://media.goto-logistics.com/TruckmateDownload/DOC/BOL/BOL-555626.pdf"
                       ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("document")
                        .font(.largeTitle)
            ScrollView  {
                ForEach(0..<documenturl.count) { i  in
                    
                    GeometryReader{
                        proxy in
                    
                         PDFKitView(url:  URL(string: documenturl[i])!)
                    }
                }
            }
                
                
        }
        
    }
}

struct ShowDocuments_Previews: PreviewProvider {
    static var previews: some View {
        ShowDocuments()
    }
}
