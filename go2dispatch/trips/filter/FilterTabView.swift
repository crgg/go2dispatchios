//
//  FilterTab.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/10/22.
//

import SwiftUI

struct FilterTabView: View {
    @Binding var selectTab : String
   
    let filter : [FilterList]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content:  {
            HStack(spacing: 0) {
                    ForEach(filter) {
                        f in
                       
                        Button {
                             selectTab = f.name
                        } label : {
                            Text(f.name)
                                .font(.caption)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .foregroundColor(
                                    selectTab == f.name ?
                                        .white : .gray)
                                    
                                .background(Color.primary.opacity(selectTab == f.name ? 1 : 0))
                                .clipShape(Capsule())
                        }
                        
                        
                        
                    }
               
            }
        })
        
    }
}

struct FilterTabView_Previews: PreviewProvider {
    static var previews: some View {
        FilterTabView(selectTab: .constant("NLTERM"),
                  filter: [FilterList( name: "YOUR"), FilterList(name: "LOCAL"), FilterList( name: "NLTERM"),
                           FilterList(name: "SCTERM"), FilterList( name: "PHTERM")])
    }
}
