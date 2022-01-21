//
//  NewFreightView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/11/22.
//



import SwiftUI

struct NewFreightView: View {
    let freight : Freight
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isOnPappReq : Bool = false
    @State var isOnPMade : Bool = false
    @State var isOnPSpot : Bool = false
    @State var isOnDappReq : Bool = false
    @State var isOnDMade : Bool = false
    @State var isOnDSpot : Bool = false
    @State var openCustomer : Bool = false
    @State private var isEditing = false
    @State var customer : String = ""
    @State var customerSelected : CustomerModel?
    @State var typeCustomer : typeCustomer = .caller
    
    

     
    
    var colorFont : Color = Color.theme.secondaryText
    
    

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label :{
                        Image(systemName: "arrow.left")
                            .font(.title2)
                        
                 
                    }
                        .padding(.horizontal, 20)
                    Spacer()
                Text("New Freight")
                    .foregroundColor(colorFont)
                    .font(Font.title2.weight(.bold))
                   
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Save")
                        
                    }.padding(.trailing, 20)

                }
                    
             
                ScrollView {
                    VStack(spacing: 15) {
                        rowView(texto:  (customerSelected != nil) ? customerSelected?.NAME ?? "" : "Select Customer", colorFont: colorFont)
                            .onTapGesture {
                                openCustomer.toggle()
                                typeCustomer =  .caller
                            }
                            .fullScreenCover(isPresented: $openCustomer) {
                                CustomerView(typeCustomer: typeCustomer.rawValue,customerSelected: self.$customerSelected )
                            }
                        
                        rowView(texto: "Bill To", colorFont: colorFont)
                            .onTapGesture {
                                openCustomer.toggle()
                                typeCustomer =  .pickup
                            }
                        
                        
       
                        shipperOptionView
                        
                        deliveryOptionView
                         
                        DetailsOption
                        
                        rowView(texto: "Trace", colorFont: colorFont)
                        rowView(texto: "Accessorial Charge", colorFont: colorFont)
                        
                        
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            
        }
   
    }
    
    private var deliveryOptionView : some View {
        
        VStack {
            rowView(texto: "Consignee", colorFont: colorFont)
             
            rowView(texto: "Delivery Dates", colorFont: colorFont)
            
            HStack {
              
                Toggle("", isOn : $isOnDappReq)
                    .labelsHidden()
                Text("App req")
                    .foregroundColor(colorFont)
                    .font(.caption)
                Toggle("", isOn : $isOnDMade)
                    .labelsHidden()
                Text("Made")
                    .foregroundColor(colorFont)
                    .font(.caption)
                Toggle("", isOn : $isOnDSpot)
                    .labelsHidden()
                Text("Spot")
                    .foregroundColor(colorFont)
                    .font(.caption)
            }
            Divider().background(colorFont)
          
        }
    }
    
    
     
    private var shipperOptionView : some View {
     
        VStack {
            rowView(texto: "Shipper", colorFont: colorFont)
                .onTapGesture {
                    openCustomer.toggle()
                    typeCustomer =  .consignee
                }
            
            rowView(texto: "Pickup Dates", colorFont: colorFont)
            
            
            
            HStack {
                Toggle("", isOn : $isOnPappReq)
                    .labelsHidden()
                Text("App req")
                    .foregroundColor(colorFont)
                    .font(.caption)
                Toggle("", isOn : $isOnPMade)
                    .labelsHidden()
                Text("Made")
                    .foregroundColor(colorFont)
                    .font(.caption)
                Toggle("", isOn : $isOnPSpot)
                    .labelsHidden()
                Text("Spot")
                    .foregroundColor(colorFont)
                    .font(.caption)
                
            }
            Divider().background(colorFont)
        }
    }
    
    
    private var DetailsOption : some View {
        HStack {
            rowView(texto: "Details", colorFont: colorFont)
        }
    }
    
    
    struct rowView : View {
        let texto : String
        let colorFont : Color
        @State private var rotation = -90.0
        var body : some View {
            
            VStack {
                HStack {
                    Text(texto)
                        .foregroundColor(colorFont)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(colorFont)
//                        .rotationEffect(.degrees(rotation))
                }.frame(maxWidth: .infinity)
                Divider().background(colorFont)
            }
        }
    }
    
}

struct NewFreightView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewFreightView(freight: TripList.sampleTrips[0].freights[0] )
                .preferredColorScheme(.light)
                .navigationBarHidden(true)
            NewFreightView(freight: TripList.sampleTrips[0].freights[0] )
                .navigationBarHidden(true)
        }
    }
}

 
