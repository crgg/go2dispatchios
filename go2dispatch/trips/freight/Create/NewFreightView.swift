//
//  NewFreightView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/11/22.
//

import SwiftUI

struct NewFreightView: View {
    @State var isOn : Bool = false
    
    var body: some View {
        VStack {
            Text("Caller")
            Text("Bill To")
            Text("Shipper")
            Text("Pickup Dates")
            HStack {
                Toggle("App req", isOn: $isOn)
                Toggle("Made", isOn: $isOn)
                Toggle("Spot", isOn: $isOn)
                
            }
            Text("Consignee")
            Text("Delivery Dates")
            HStack {
                Toggle("App req", isOn: $isOn)
                Toggle("Made", isOn: $isOn)
                Toggle("Spot", isOn: $isOn)
                
            }
            Text("Details")
                
            
        }
    }
}

struct NewFreightView_Previews: PreviewProvider {
    static var previews: some View {
        NewFreightView()
    }
}
