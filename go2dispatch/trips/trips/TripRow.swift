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
    
    @State private var ShowMenuAction = false
    
    @State private var openDriver = false
    @State private var openTrailerSelected = false
    
    @State private var openFreightAssign = false
    
    @Binding  var showFreights : Bool
    @Binding  var isDeassign : Bool  
 
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
                    Text("Status")
                        .foregroundColor(.green)
                        .font(.caption2)
                    TextTripView(texto: trip.status, colorFont: colorFont)
                    Spacer()
                    Button {
                        ShowMenuAction.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(colorFont)
                        }
                        .actionSheet(isPresented: $ShowMenuAction) {
                            ActionSheet(
                                title: Text("Trip # \(String(trip.trip_number))"),
                                buttons: [
                                    .default(Text("Change Status")) {
                                        
                                    },
                                    .default(Text("Assign freight")) {
                                        openFreightAssign.toggle()
                                        
                                    },
                                    .default(Text(optionMenuAction(texto:
                                                                    "Assign Driver", value: trip.driver_id ?? ""))
                                        .foregroundColor(.green)
                                            ) {
                                                openDriver.toggle()
                                                
                                            },
                                    .default(Text(optionMenuAction(texto:
                                                                    "Assign Truck", value: trip.truck_id ?? ""))
                                        .foregroundColor(.green)
                                            ) {
                                                
                                            },
                                    .default(Text(optionMenuAction(texto:
                                                                    "\(trip.trailer_id != nil ? "Deassign" : "Assign") Trailer", value: trip.trailer_id ?? ""))
                                        .foregroundColor(.green)
                                            ) {
                                                if trip.trailer_id != nil {
                                                    viewModel.typeDeassign = .trailer(trip: trip)
                                                    self.isDeassign.toggle()
//                                                    return
                                                } else {
                                                    openTrailerSelected.toggle()
                                                }
                                            },
                                    .destructive(Text("Cancel")) {
                                        
                                    }
                                ]
                            )
                        }

                    }
                    .foregroundColor(.white)
                     
                        
//                        .confirmationDialog("Trip # \(trip.TRIP_NUMBER)", isPresented: $ShowMenuAction, titleVisibility: .visible) {
//
//                        }
//
                        
                    
                    
                    
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
                    
                    // action
                    Spacer()
          
                    
                    Button {
//                        rotation = trip.expland ? -90 : 0
                         viewModel.explanded(trip.trip_number, expland:  !trip.expland)
                        
                    } label: {
                        Text("Freights")
                            .font(.system(size: 15))
                            .padding(6)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius:  25)
                                                   .stroke(Color.white, lineWidth: 1)
                            )
//                        Image("ic_explain")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(colorFont)
//                            .rotationEffect(.degrees(rotation))
                    }
                    .background(trip.expland ? Color.blue : Color.clear)
                    .cornerRadius(25)
                   
                     
                    
                     
                    
//                    Button(action: {
//                        rotation = trip.expland ? -90 : 0
//                         viewModel.explanded(trip.trip_number, expland:  !trip.expland)
//
//                    }) {
//                        Text("Freights")
//                            .font(.caption)
//                        Image("ic_explain")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(colorFont)
//                            .rotationEffect(.degrees(rotation))
//
//                    }
                }
//                Divider().background(colorFont)
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
        .fullScreenCover(isPresented: $openDriver) {
            DriversView(trip: trip)
        }
        .fullScreenCover(isPresented: $openFreightAssign) {
            BillNumberView(trip: trip)
        }
        .fullScreenCover(isPresented: $openTrailerSelected) {
            TrailersView(trip: trip).environmentObject(viewModel)
        }

            
    }
    
 
    private func optionMenuAction (texto : String, value : String)-> String{
        
        if value.isEmpty {
            return texto
        }
        
        return "\(texto) (\(value)) "
        
    }
    
    

}




 

struct TripRow_Previews: PreviewProvider {
    static var previews: some View {
        TripRow(trip: TripList.sampleTrips[0],
                showFreights: .constant(false), isDeassign: .constant(false)   )
               .environmentObject(TripListViewModel())
    }
    
}
