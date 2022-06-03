//
//  TrailersView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/27/22.
//

import SwiftUI

struct TrailersView: View {

    @State private var query = ""
    @StateObject private var viewModel: TrailerViewModel
    
    @EnvironmentObject var viewModeltrip : TripListViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init (trip: TripList) {
        
        _viewModel =  StateObject(wrappedValue: TrailerViewModel(trip: trip))
        
    }
    
    var body: some View {
        
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                HeaderTrailersView(titulo: "Assign Trailer to \(String(viewModel.trip.trip_number))").environmentObject(viewModel)
                SearchTrailersView(query: $query)
                BodyTrailersView(trailers: viewModel.trailers, query: $query).environmentObject(viewModel)
                
            }.alert(viewModel.typeMessage.rawValue, isPresented: $viewModel.isError, actions: {
                switch viewModel.typeMessage {
                case .error :
                    Button("Ok", action: {})                   
                case .warning :
                    Button("Yes", action: {
                        viewModel.assingTrailerWarning()
                    })
                    Button("No", action: {})
                case .message :
                    Button("Done", action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                case .success :
                    Button("OK", action: {
                        if case .success(trip: let trip1) = viewModel.serviceMessage {
                            self.viewModeltrip.updateTrip(trip: trip1)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    })
                case .nothing :
                    Button("none", action: {})
                }
            }, message: {

                Text(viewModel.messageOut)
            })
            .padding(10)
            
        }
    }
    
    struct BodyTrailersView : View {
        @EnvironmentObject var viewmodel : TrailerViewModel
       var trailers : [TrailerModel]
        @Binding var query: String
        var body: some View {
            List {
                ForEach(self.viewmodel.getSortedFiltered(query: query)) {
                    tra in
                    Button {
                        
                        self.viewmodel.selectedTrailer =  tra
                        self.viewmodel.assignTrailer()
                    } label: {
                        
                        TrailerRow(trailer: tra)
                            .environmentObject(viewmodel)
                          
                    }  .listRowInsets(EdgeInsets())
                    
                }.id(UUID())
//                    . buttonStyle(BorderedButtonStyle())
                
            }.listStyle(PlainListStyle())
        }
    }
    
    struct SearchTrailersView : View {
        @Binding var query : String
        
        var body: some View {
            HStack {
                SearchBar(text: $query)
            }
            
        }
    }
    struct HeaderTrailersView : View {
        @EnvironmentObject var viewmodel : TrailerViewModel
        var titulo : String
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        var body: some View {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }.padding(.horizontal, 5)
                Spacer()
                Text(titulo).foregroundColor(.white)
                Spacer()
                Button {
                    self.viewmodel.get()
                } label: {
                    Text("Refresh")
                }
            }.frame(maxWidth : .infinity)
            
        }
        
    }
}

struct TrailersView_Previews: PreviewProvider {
    static var previews: some View {
        TrailersView(trip: TripList.sampleTrips[0])
    }
}
