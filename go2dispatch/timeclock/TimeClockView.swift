//
//  TimeClockView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/27/21.
//

import SwiftUI


struct TimeClockView: View {
    
    @StateObject var viewmodel = TimeClockViewModel()
    
    @State var timeLogHistory : [TimeLogHistory] = []
    
    @State var isError  = false
    
     @State var textColor  = Color.white
//    init() {
//        UITableView.appearance().backgroundColor = .clear
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.white)]
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.white)]
//    }
//    
    var body: some View {
        ZStack {
            Color("Marine")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing : 5) {
                
                Text(viewmodel.timeStart).font(.title).frame(maxWidth:.infinity, alignment: .center).foregroundColor(textColor)
                
                
                if  viewmodel.isLoading {
                    LoadingView().frame(maxWidth : .infinity, maxHeight: 20, alignment: .trailing)
                }
                Button(action: {
                    viewmodel.pickTime()
                    
                }, label: {Text(viewmodel.titleButton).foregroundColor(Color.white)
                    
                })
                    .disabled(viewmodel.isLoading)
                    .padding(40)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(viewmodel.colorButton)
                    .mask(Circle())
                    .alert(isPresented: $viewmodel.isError) {
                        Alert(title: Text("Error"), message: Text(viewmodel.messageError), dismissButton: .default(Text("OK")))
                        
                    }
                
                
                
                HStack {
                    Image("ic_location").resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .clipped()
                    Text(viewmodel.clockInLocationLabel).font(.caption).foregroundColor(textColor)
                }
 
                Text("OverView")
                    .frame(maxWidth : .infinity, alignment: .center)
                    .font(.headline).foregroundColor(textColor)
                List {
                    ForEach(viewmodel.timeLogHistory, id: \.SHIFT_ID) {
                        time_history in
                        Section(header:
                                    HStack {
                            Text("Shift Date :").foregroundColor(textColor)
                            Text(time_history.SHIFT_DATE ?? "").foregroundColor(
                                textColor).font(.title3)
                        } .listRowInsets(EdgeInsets())
                                    .background(  Color("Marine"))
                                , footer:
                                    
                            HStack {
                                
                            Text("Total").foregroundColor(textColor)
                            Text(time_history.TOTALHOURS_TIME_FORMAT ?? "0.0").foregroundColor(textColor)
                                .font(.title3)
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                                    .background(  Color("Marine"))
                                    .listRowInsets(EdgeInsets())
                                    
                        
                                
                        )   {
                            
                                ForEach(time_history.data!, id: \.ID ) {
                                    item in
                                    TimeClockRow(timeHistory: item, textColor : textColor) .listRowInsets(EdgeInsets())
                                       
                                }
                           
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .listStyle(GroupedListStyle())
                    
                
            }.padding(.horizontal, 10.0)
                .frame(maxWidth : .infinity)
                .onAppear {
                    print("Entramos a View")
                    viewmodel.getHistory()
                    UITableView.appearance().backgroundColor = UIColor(named: "Marine")
                }
                
        }
        .navigationBarTitle("") //this must be empty
           .navigationBarHidden(true)
           .navigationBarBackButtonHidden(true)
           
       
    }
    
    
  
    
}

struct TimeClockView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        TimeClockView()
    }
}
