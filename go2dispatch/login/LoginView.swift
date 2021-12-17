//
//  LoginView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/26/21.
//

import SwiftUI
 

struct LoginView : View {
    @State var email = "ramon@gotologistics.net"
    @State var password = "ramon"
    @State var isActiveHomeView = false
    @State var isErrorField  = false
    @State var isLoading = false
    @State var messageError = ""
    @EnvironmentObject var vm: UserStateViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                VStack(alignment: .leading) {
                    // email
                    Text("Email").foregroundColor(Color("Dark-cian"))
                    ZStack (alignment: .leading) {
                        if email.isEmpty {
                            Text("sample@gotologistics.net")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        TextField("", text : $email).foregroundColor(.white)
                        
                    }
                    Divider().frame(height: 2).background(Color("Dark-cian")).padding(.bottom)
                    //password
                    Text("Password").foregroundColor(.white)
                    ZStack (alignment: .leading) {
                        if password.isEmpty {
                            Text("Write your password")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        SecureField("", text : $password).foregroundColor(.white)
                        
                        
                    }
                    Divider().frame(height: 2).background(Color("Dark-cian")).padding(.bottom)
                    
                    Text("Forget your Password?").font(.footnote)
                        .frame(width: 300,  alignment: .trailing).foregroundColor(Color("Dark-cian")).padding(.bottom)
                } // end vstack after scrollview
                
                Button(action: startSession, label: {
                    Text("Login In")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: 11, leading: 18, bottom: 11, trailing: 18))
                        .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color("Dark-cian"), lineWidth: 1.0)
                                    .shadow(color:.white , radius: 6) )
                    
                    // infinity : cresca lo necesario
                }).alert(isPresented: $isErrorField) {
                    Alert(title: Text("Error"), message: Text(messageError), dismissButton: .default(Text("OK")))
                    
                }
                
                //            .frame(width: .infinity , height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                Text("Start Social media").foregroundColor(.white).padding(.top, 80)
//                    .padding(.bottom , 25)
//                Spacer()
//                HStack {
//                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
//                        Text("Facebook")
//                    }.foregroundColor(.white)
//                    .font(.caption)
//                    .frame(maxWidth: 125, alignment: .center )
//                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
//                    .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(.blue))
//
//
//
//                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
//                        Text("Twitter")
//                    }.foregroundColor(.white)
//                    .font(.caption)
//                    .frame(maxWidth: 125,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
//                    .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(.blue))
//
//
//                }
                if isLoading {
                    LoadingView()
                }
                
            }.padding(.horizontal, 77.0)
            
//            NavigationLink(
//                destination: Home(),
//                isActive: $isActiveHomeView,
//                label : {
//                    EmptyView()
//                })
        }// end Scrolview
        
    }
    func startSession() {
        isErrorField = false
        
        
        guard !email.isEmpty else {
            isErrorField = true
            messageError = "Email is Empty"
            return
        }
        guard !password.isEmpty else {
            isErrorField = true
            messageError = "Password is empty"
            return
        }
        
        isLoading = true
//        let loginSearc = LoginViewModel()

        LoginViewModel.login(email: email, password: password) {
            (status, error) in
            if status  {
                 
                isLoading = false
                vm.signIn()
                return
            }
            
            if let error = error {
               
                messageError  = error
                isErrorField = true
            }
            
            isLoading = false
        }
        
        
        
//        isActiveHomeView = true
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .red)).scaleEffect(3)
        }
    }
}
