//
//  AddressView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/12/22.
//

import SwiftUI

struct AddressView: View {
    let companyName : String
    let address : String
    let colorFont: Color
    let titule : String
    var body: some View {
        VStack(alignment: .leading) {
            Text(titule)
                .foregroundColor(.green)
                .font(.caption)
            TextTripView(texto: companyName , colorFont: colorFont).font(Font.body.bold())
            TextTripView(texto: separate(address) , colorFont: colorFont)
            TextTripView(texto: separate2(address) , colorFont: colorFont)
        }
    }
    
    func separate (_ value : String) -> String {
        guard value.contains(",") else {
            print("don't have coma")
            return ""
        }
        let index = value.firstIndex(of: ",") ?? value.endIndex

        // substring
        let firstpart = value[..<index]

        // todo los substring se debe pasar a string para que aquiera las propiedades de string
        return String(firstpart)
    }
    
    func separate2 (_ value : String) -> String {
        guard value.contains(",") else {
            print("don't have coma")
            return ""
        }
        
        let index = value.firstIndex(of: ",")   ?? value.endIndex
        

        // substring
            let index2 = value.index(index, offsetBy: 2)
            let firstpart = value[index2..<value.endIndex]
      

        // todo los substring se debe pasar a string para que aquiera las propiedades de string
        return String(firstpart)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(companyName: "TRUST AIR CARGO", address: "2206 LIVELY BLVD", colorFont: .white, titule: "Customer")
    }
}
