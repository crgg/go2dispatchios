//
//  FreigthView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/5/22.
//

import SwiftUI

struct FreigthView: View {
    let freights : [Freight]
    let colorFont : Color = .white
    @State var openFotos : Bool = false
    @State var openDocuments : Bool = false
   
    
    @EnvironmentObject var viewModel : TripListViewModel
    var body: some View {
        ForEach( freights , id: \.id) { fb in
            ZStack {
                Color.theme.background
                FreighRow(fb: fb)
            }
        }
    }
}




struct FreigthView_Previews: PreviewProvider {
    static var previews: some View {
        FreigthView(freights: TripList.sampleTrips[0].freights)
            .environmentObject(TripListViewModel())
        
 }
    }

