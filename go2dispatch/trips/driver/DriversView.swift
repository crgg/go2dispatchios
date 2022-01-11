//
//  DriversView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/10/22.
//

import SwiftUI

struct DriversView: View {
    
    @StateObject var viewmodel = DriverViewModel()
    
    let trip : TripList
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    let driverTripModel : [DriverTripModel] = DriverTripModel.sample
    @State var selectTab : String = "NLTERM"
    @State private var query = ""
    
    var colorFont : Color = .white
    
    var  filter : [FilterList] = [
    FilterList(name: "NLTERM"),
    FilterList(name: "AVAIL"),
    FilterList(name: "ASSIGN"),
    FilterList(name: "PHTERM"),
    ]
    
    var body: some View {
        ZStack {
            Color("Marine").ignoresSafeArea()
            VStack (alignment: .leading)  {
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label :{
                        Image(systemName: "arrow.left")
                            .font(.title2)
                    }.padding(.horizontal, 5)
                    
                    Text("Assign Driver to \(String(trip.trip_number))")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                FilterTabView(selectTab: $selectTab, filter: filter)
                HStack {
                    
                    SearchBar(text: $query)
                }
                
                ScrollView  {
                    ForEach(viewmodel.getStoredFiltered(query: query)) {
                             driver in
                        
                        HStack(spacing: 5) {
                            DownloadingImageView(url: "", key: "")
                                .frame(width: 70, height: 70)
                            VStack (alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        TextTripView(texto: driver.DRIVER_ID, colorFont: colorFont)
                                        TextTripView(texto: driver.NAME, colorFont: colorFont)
                                    }
                                }
                                HStack {
                                    Text("Truck # ")
                                        .font(.caption2)
                                        .foregroundColor(.green)
                                
                                    
                                    Text(driver.DEFAULT_PUNIT ?? "")
                                        .foregroundColor(.white)
                                        .font(.caption2)
                                    
                                }
                                HStack {
                                    Text("Status ")
                                        .font(.caption2)
                                        .foregroundColor(.green)
                                
                                    
                                    Text(driver.STATUS)
                                        .foregroundColor(.white)
                                        .background(Color.yellow.opacity(driver.STATUS == "AVAIL" ? 1: 0))
                                        .font(.caption2)
                                 
                                        
                                }
                                
                            }
                         
                            Spacer()
                            
                          
                            VStack( spacing: 5) {
                                HStack  {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Current Zone ")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                        Text("Current Trip")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                        Text("Current Trip")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                        Text("Cell Phone")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                      
                                    }
                                    VStack(alignment: .trailing) {
                                        TextTripView(texto: driver.CURRENT_ZONE , colorFont: colorFont)
                                        
                                        TextTripView(texto: driver.CURRENT_TRIP ?? "", colorFont: colorFont)
                                        
                                        TextTripView(texto: driver.NEXT_TRIP ?? "", colorFont: colorFont)
                                        TextTripView(texto: driver.CELL_PHONE ?? "", colorFont: colorFont)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            
                          
                        }
                        
                        Divider()
                    }
                     
                }
                
                
            }
            
        } .onAppear {
            viewmodel.getDrivers()
        }
    
    }
}

struct DriversView_Previews: PreviewProvider {
    static var previews: some View {
        DriversView(trip: TripList.sampleTrips[0])
    }
}
