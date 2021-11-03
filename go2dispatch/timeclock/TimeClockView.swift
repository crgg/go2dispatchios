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
 
    
    var body: some View {
        ZStack {
            Color("time_clock_bg")
                .ignoresSafeArea()
            
            
            VStack(alignment: .leading, spacing : 5) {
                
                Text(viewmodel.timeStart).font(.title).frame(maxWidth:.infinity, alignment: .center)
                
                
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
                    .alert(isPresented: $isError) {
                        Alert(title: Text("Error"), message: Text(viewmodel.messageError), dismissButton: .default(Text("OK")))
                        
                    }
                
                
                
                HStack {
                    Image("ic_location").resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .clipped()
                    Text(viewmodel.clockInLocationLabel).font(.caption)
                }
                Text("OverView")
                    .frame(maxWidth : .infinity, alignment: .center)
                    .font(.headline)
    
                
                List {
                    
                    ForEach(viewmodel.timeLogHistory, id: \.SHIFT_ID) {
                        time_history in
                        Section(header:
                                    HStack {
                            Text("Shift Date :")
                            Text(time_history.SHIFT_DATE ?? "")
                        }
                                , footer:
                                    HStack {
                            Text("Total").font(.footnote)
                            Text(time_history.TOTALHOURS_TIME_FORMAT ?? "0.0")
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                                
                        )  {
                            ForEach(time_history.data!, id: \.ID ) {
                                item in
                                TimeClockRow(timeHistory: item)
                            }
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .listStyle(PlainListStyle())
                
            }.padding(.horizontal, 10.0)
                .frame(maxWidth : .infinity)
                .onAppear {
                    print("Entramos a View")
                    viewmodel.getHistory()
                }
        }
    }
    
    
  
    
}

struct TimeClockView_Previews: PreviewProvider {
    static var previews: some View {
        TimeClockView()
    }
}
