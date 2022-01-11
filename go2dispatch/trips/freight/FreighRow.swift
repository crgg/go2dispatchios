//
//  FreighRow.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/11/22.
//

import SwiftUI

struct FreighRow: View {
    let colorFont : Color = .white
    let fb : Freight
    @State var openFotos : Bool = false
    @State var openDocuments : Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                TextTripView(texto: fb.TYPE ?? ""  ,colorFont: colorFont)
                Text(fb.BILL_NUMBER)
                    .foregroundColor(.blue)
                IconTripView(colorFont: colorFont, img: "gps")
                TextTripView(texto: fb.CURR_ZONE_DESC ?? "", colorFont: colorFont)
                Spacer()
                TextTripView(texto: fb.BILL_STATUS ?? "", colorFont: colorFont)
            }
            HStack {
              addressView(companyName: fb.ORIGNAME ?? "", address: fb.ADDRESS_ORIGIN ?? "", colorFont: colorFont,
                          titule : "Shipper")
                Spacer()
                addressView(companyName: fb.DESTNAME ?? "", address: fb.ADDRESS_DESTINE ?? "", colorFont: colorFont, titule: "Consignee" )
            }
            HStack {
                details(titule: "Pallets", value: fb.PALLETS ?? "", colorFont: colorFont)
                details(titule: "Spots", value: fb.PIECES ?? "", colorFont: colorFont)
                details(titule: "Weight", value: fb.WEIGHT ?? "", colorFont: colorFont)
                
                if checkDocument("F") {
                    Button {
                       
                        openFotos.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "camera")
                                .font(.system(size: 15, weight: .bold))
                            
                                .foregroundColor(colorFont)
                            
                            
                            Text("Photos")
                                .font(.caption)
                            
                            
                        }.padding(5)
                    }.foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(.infinity)
                }
                
                if checkDocument("D") {
                    Button {
                     
                        openDocuments.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                                .font(.system(size: 15, weight: .bold))
                            
                                .foregroundColor(colorFont)
                            
                            
                            Text("Doc")
                                .font(.caption)
                            
                            
                        }.padding(5)
                    }.foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(.infinity)
                }
            }.padding(.vertical, 1)
            Divider().background(colorFont)
         
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
        
            .fullScreenCover(isPresented: $openFotos) {
                ShowPhotoGallery(fotos: getCurrentDocuments("F")
                                 , freight: fb)
                
            }
            .fullScreenCover(isPresented: $openDocuments) {
                
                ShowDocuments(fotos: getCurrentDocuments("D"), freight: fb)
                
            }
    }
    struct details : View {
        let titule : String
        let value : String
        let colorFont : Color
        
        var body : some View {
            VStack {
                TextTripView(texto:titule , colorFont: .green)
                TextTripView(texto: value, colorFont: colorFont)
                
            }
        }
    }
    
    struct addressView : View {
      
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
    
    func checkDocument(_ typeDoc : String) -> Bool {
        return (self.fb.fotos.first(where : { $0.typedocument == typeDoc }) != nil)
    }
    func getCurrentDocuments(_ typeDoc : String) -> [fotos] {
        return  self.fb.fotos.filter { $0.typedocument == typeDoc }
    }
    
}

struct FreighRow_Previews: PreviewProvider {
    static var previews: some View {
        FreighRow(fb: TripList.sampleTrips[0].freights[0])
    }
}
