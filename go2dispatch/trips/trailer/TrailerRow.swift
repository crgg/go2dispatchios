//
//  TrailerRow.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/27/22.
//

import SwiftUI

//
//  TripRow.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/5/22.
//

import SwiftUI

struct TrailerRow: View {
    
    var trailer : TrailerModel
    @EnvironmentObject var viewModel : TrailerViewModel
    let widthIcon : CGFloat = 20
    let heightIcon : CGFloat = 15
    let colorFont : Color = .white

    var body: some View {
        ZStack {
            Color("Marine")
            
            VStack(alignment: .leading) {
                
                HStack (spacing: 2) {
                    VStack {
                        
                        Text(String(trailer.trailerID))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 5)
                            .foregroundColor(colorFont)
                            .border(.green, width: 1)
                            .font(.title2)
                    }
                    Spacer()
                    standarView(texto: trailer.datumCLASS ?? "", colorFont: colorFont, titulo: "class", align: .trailing)

                    Spacer()
                    standarView(texto: trailer.status , colorFont: colorFont, titulo: "Status", align: .trailing)
                    
                    Spacer()
         
 
                    
                    
                }.frame(maxWidth: .infinity)
              
               
                
                HStack {
   
                    standarView(texto: trailer.currentZoneDesc ?? "" , colorFont: colorFont, titulo: "📍", align: .leading)
                     
                    Spacer()
                    standarView(texto: trailer.zone ?? "", colorFont: colorFont, titulo: "Zone", align: .trailing)
                    Spacer()
                    standarView(texto: trailer.currentTrip ?? "", colorFont: colorFont, titulo: "C.Trip", align: .trailing)
          

      
            }
                .padding(.horizontal, 5)
                .padding(.vertical,5)
                .frame(maxWidth: .infinity)
               
        }
   

            
    }
    


    }
    
    struct standarView : View {
        var texto : String
        let colorFont : Color
        let titulo : String
        let align : Alignment
        var body: some View {
            HStack( spacing: 1) {
                Text(titulo)
                    .foregroundColor(.green)
                    .font(.caption2)
                TextTripView(texto: texto, colorFont: colorFont)
            }.frame( maxWidth: .infinity, alignment: align)
        }
        
        
    }
    
    
}




 

struct TrailerRow_Previews: PreviewProvider {
    static var previews: some View {
        TrailerRow(trailer: TrailerModel.sampleTrailer[0])
               .environmentObject(TripListViewModel())
    }

}
