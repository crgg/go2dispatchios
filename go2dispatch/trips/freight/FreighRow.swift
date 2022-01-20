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
              AddressView(companyName: fb.ORIGNAME ?? "", address: fb.ADDRESS_ORIGIN ?? "", colorFont: colorFont,
                          titule : "Shipper")
                Spacer()
                AddressView(companyName: fb.DESTNAME ?? "", address: fb.ADDRESS_DESTINE ?? "", colorFont: colorFont, titule: "Consignee" )
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
