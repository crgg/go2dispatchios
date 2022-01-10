//
//  Trip_ListView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import SwiftUI

struct Trip_ListView: View {
    
        
    let trips = TripList.sampleTrips
    @StateObject var viewmodel = TripListViewModel()
    @State private var query = ""
    @State var isNewChat = false
    @State var showFreights =  false
    @State var showOverlay : Bool  = false
    @State var openDetails : Bool = false
     
    
    
    
    var selectTab : String = "YOUR"
    let filter : [TripFilter] = [TripFilter( name: "YOUR"), TripFilter(name: "LOCAL"), TripFilter( name: "NLTERM"),
                                 TripFilter(name: "SCTERM"), TripFilter( name: "PHTERM")]
    
    var body: some View {
         
            ZStack {
                Color("Marine").ignoresSafeArea()
                
                VStack {
                    Text("Multimode")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false, content:  {
                        HStack(spacing: 0) {
                                ForEach(filter) {
                                    f in
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
                    })
                    
                    
                    HStack {
                        
                        SearchBar(text: $query)
                    }
                    
                    ScrollView {
                        
                        ForEach (viewmodel.getSortedFiltered(query: query)) { trip in
                        
                        TripRow(trip: trip, showFreights : $showFreights)
                            .environmentObject(viewmodel)
                            .listRowInsets(EdgeInsets())
 
                        }
                    
                }.listStyle(PlainListStyle())
                    
            
        }.onAppear {
            
            UITableView.appearance().backgroundColor = UIColor(named: "Marine")
            print("Entramos a View")
            viewmodel.getTrips()
            //            self.showOverlay =  viewmodel.getIsNewMessage()
            
        }
        
    
    }
   

}
    
 
}
 
struct Trip_ListView_Previews: PreviewProvider {
    static var previews: some View {
        Trip_ListView()
    }
}
