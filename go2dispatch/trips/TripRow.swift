//
//  TripRow.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/5/22.
//

import SwiftUI

struct TripRow: View {
    
    var trip : TripList
    @EnvironmentObject var viewModel : TripListViewModel
    let widthIcon : CGFloat = 20
    let heightIcon : CGFloat = 15
    let colorFont : Color = .white
    @State private var rotation = -90.0
    
    @Binding  var showFreights : Bool
    
    @State var openFreight = false
    var body: some View {
        ZStack {
            Color("Marine")
            VStack(alignment: .leading) {
                HStack (spacing: 2) {
                    Text(String(trip.trip_number))
                        .padding(.vertical, 2)
                        .padding(.horizontal, 5)
                        .foregroundColor(colorFont)
                        .border(.green, width: 1)
                        .font(.caption)
                    TextTripView(texto: trip.description ?? "" , colorFont: colorFont)
                    
                    Spacer()
                    TextTripView(texto: trip.status, colorFont: colorFont)
                    
                }.frame(maxWidth: .infinity)
              
                HStack {
                    IconTripView(colorFont: colorFont, img: "driver2")
                    TextTripView(texto: trip.driver_id ?? "No Driver", colorFont: colorFont)
                    if trip.trailer_id != nil{
                        IconTripView(colorFont: colorFont, img: "trailer")
                        TextTripView(texto: trip.trailer_id ?? "",
                        colorFont: colorFont)
                    }
                    IconTripView(colorFont: colorFont, img: "truck")
                    
                    TextTripView(texto: trip.truck_id  ?? "",
                                       colorFont: colorFont)
                    
                }
                
                HStack {
                    IconTripView(colorFont: colorFont, img: "gps")
                    TextTripView(texto: trip.current_zone_desc ?? "", colorFont: colorFont)
                    
                    Button {
         
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(colorFont)
                            Text("Loadcard")
                                .font(.caption)
                        }.padding(5)
                    }.foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(.infinity)
                    
                     
                    Spacer()
                    Button(action: {
                        rotation = trip.expland ? -90 : 0
                         viewModel.explanded(trip.trip_number, expland:  !trip.expland)
                         
                    }) {
                        
                        Image("ic_explain")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorFont)
                            .rotationEffect(.degrees(rotation))
                    
                             
                        
                    }
                }
                Divider().background(colorFont)
                if trip.expland {
                    if  trip.freights.count > 0 {
                        FreigthView(freights: trip.freights)
                    } else {
                        Text("no have freight assign")
                            .foregroundColor(colorFont)
                    }
                }
                
            }.padding(.horizontal, 5)
                .padding(.vertical,5)
               
        }
            
    }
    

}




 

struct TripRow_Previews: PreviewProvider {
    static var previews: some View {
        TripRow(trip: TripList.sampleTrips[0],
                showFreights: .constant(false)   )
               .environmentObject(TripListViewModel())
    }
    
}
