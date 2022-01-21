//
//  CustomerView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/12/22.
//

import SwiftUI
import Accelerate

struct CustomerView: View {
    @State var customer : String = ""
    var colorFont = Color.white
    @State var isEditing : Bool = false
     var typeCustomer : String
    
    @StateObject var vm : CustomerMV = CustomerMV()
    @Binding var customerSelected : CustomerModel?
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack (alignment : .leading) {
          
                customerViewHeader
                        
                        HStack {
                            SearchBar(text: $vm.searchText)
                        }
                
                
                List {
                    
                    ForEach(vm.customers) {
                        cust in
                        Button {
                            self.customerSelected  = cust
                            self.presentationMode.wrappedValue.dismiss()
                            
                            
                        } label: {
                            CustomerRowView(cust: cust)
                               
                        } .listRowInsets(.init(top:0, leading: 0, bottom: 0, trailing: 0) )
                        
                    }
                    
                    
                }
                .listStyle(PlainListStyle())
                

       
            }
            .padding(.top , 20)
           
        }
        .onAppear {
            vm.getCustomer(typeCustomer: typeCustomer)
        }
        
    }
 
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView(typeCustomer: "caller", customerSelected: .constant(dev.customers[0]))
    }
}


extension CustomerView {
    private var customerViewHeader : some View {
        
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label :{
                Image(systemName: "arrow.left")
                    .font(.title2)
            }.padding(.horizontal, 5)
            Spacer()
            Text("Customer list")
                
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width/3,  alignment: .center)
            Spacer()
        }.padding(.horizontal,10)
    }
}
