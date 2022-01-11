//
//  BillNumberView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/11/22.
//

import SwiftUI

struct BillNumberView: View {
    
    @StateObject var viewmodel = BillNumberVM()
    @State private var query = ""
    let filter : [FilterList] = [FilterList( name: "Deliveries"), FilterList(name: "Pcikups")]
    let billNumbers : [Freight] =  TripList.sampleTrips[0].freights
    let trip : TripList
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var selectTab : String = "Deliveries"
    
    var body: some View {
        ZStack {
            Color("Marine").ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label :{
                        Image(systemName: "arrow.left")
                            .font(.title2)
                    }.padding(.horizontal, 5)
                    Spacer()
                    Text("Assign Freight to \(String(trip.trip_number)) ")
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button {
                        
                        
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(10)
                        
                    }
                }
                FilterTabView(selectTab: $selectTab, filter: filter)
                // search var
                HStack {
                    
                    SearchBar(text: $query)
                }
                
                ScrollView {
                    ForEach(billNumbers, id: \.id) {
                        fb in
                        ZStack {
                            Color("Marine")
                            FreighRow(fb: fb)
                        }
                    }
                }
                
            }
            
        }
        
    }
}

struct BillNumberView_Previews: PreviewProvider {
    static var previews: some View {
        BillNumberView(trip: TripList.sampleTrips[0])
    }
}
