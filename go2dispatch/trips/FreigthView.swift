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
                Color("Marine")
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
                        
                        if viewModel.checkDocument(photos: fb.fotos, typeDoc: "F") {
                            Button {
                                viewModel.setCurrentFotos(fb.fotos)
                                viewModel.setCurrentFreight(fb)
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
                        
                        if viewModel.checkDocument(photos: fb.fotos, typeDoc: "D") {
                            Button {
                                viewModel.setCurrentDocument(fb.fotos)
                                viewModel.setCurrentFreight(fb)
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
            }
            .fullScreenCover(isPresented: $openFotos) {
                ShowPhotoGallery(fotos: viewModel.getCurrentFotos(), freight: viewModel.getCurrentFreight())
                
            }
            .fullScreenCover(isPresented: $openDocuments) {
                ShowPhotoGallery(fotos: viewModel.getCurrentDocuments(), freight: viewModel.getCurrentFreight())
                
            }
            
            
            
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
    
 
}




struct FreigthView_Previews: PreviewProvider {
    static var previews: some View {
        FreigthView(freights: TripList.sampleTrips[0].freights)
            .environmentObject(TripListViewModel())
 }
    }

