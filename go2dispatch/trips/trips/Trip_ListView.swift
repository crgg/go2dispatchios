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
    @State var ShowMenuAction2 : Bool = false
    @State var openNewFreight : Bool = false
    
    
    
    @State var selectTab : String = "YOUR"
    
    let filter : [FilterList] = [FilterList( name: "YOUR"), FilterList(name: "LOCAL"), FilterList( name: "NLTERM"),
                                 FilterList(name: "SCTERM"), FilterList( name: "PHTERM")]
    
    var body: some View {
         
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack {
                    HStack {
                       
                        Spacer()
                        Text("Multimode")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            ShowMenuAction2 = true
                        } label: {
                            CircleButtonView(iconName: "plus")
                            
                        }
                
                    }.frame(maxWidth: .infinity)
                    ScrollView(.horizontal, showsIndicators: false, content:  {
                        HStack(spacing: 0) {
                               FilterTabView(selectTab: $selectTab, filter: filter)
                        }
                    })
                    
                    
                    HStack {
                        
                        SearchBar(text: $query)
                    }      .actionSheet(isPresented: $ShowMenuAction2) {
                        ActionSheet(
                            title: Text("Action"),
                            buttons: [
                                .default(Text("New Trip")) {
                                    
                                },
                                .default(Text("New Freight")) {
                                     
                                    openNewFreight.toggle()
                                },
                                 
                                .destructive(Text("Cancel")) {
                                        
                                 }
                            ]
                        )
                    }
                    
                    
                    
                    List {
                        
                        ForEach (viewmodel.getSortedFiltered(query: query)) { trip in
                        
                        TripRow(trip: trip, showFreights : $showFreights)
                            .environmentObject(viewmodel)
                            .listRowInsets(EdgeInsets())
 
                        }.id(UUID())
                            .buttonStyle(BorderlessButtonStyle())
                    
                }.listStyle(PlainListStyle())
                    
            
        }  .fullScreenCover(isPresented: $openNewFreight) {
            NewFreightView(freight: TripList.sampleTrips[0].freights[0])
        }
          
                
                .onAppear {
            
            UITableView.appearance().backgroundColor = UIColor(named: "Marine")
            print("Entramos a View")
           // viewmodel.getTrips()
            //            self.showOverlay =  viewmodel.getIsNewMessage()
            
        }
        
    
    }
     

}
    
 
}
 
struct Trip_ListView_Previews: PreviewProvider {
    static var previews: some View {
        Trip_ListView()
            .navigationBarHidden(true)
    }
}
