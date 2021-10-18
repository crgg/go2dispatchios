//
//  CodeVerifyView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/27/21.
//

import SwiftUI

struct CodeVerifyView: View {
    @State var isErrorField  = false
    @State var messageError = ""
    @State var isRegistrationView = false
    
    @ObservedObject var codeVery  = TextFieldManager(limit : 6)
    
    @State var isLoading = false
    var body: some View {
    
        ZStack  {
            Color(red: 18/255, green: 32/255, blue: 61/255, opacity: 1.0).ignoresSafeArea()
            VStack (spacing : 20) {
                Image("app_logo").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:80, height: 80, alignment: .top)
                    .padding(.bottom, 22)
                 
                Text("Enter the Code").foregroundColor(.white)
                
                TextField("", text : $codeVery.text, onEditingChanged: onEditingChanged(_:), onCommit: onCommit)
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("Dark-cian"), lineWidth: 4)
                        )
//                    .background(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke( Color.gray, lineWidth : 3)).padding()
                     
                    .font(Font.system(size: 20))
                    .foregroundColor(.white)
                    .keyboardType(.numberPad)
                    .padding(10)
                    
                    
//                Divider().frame(height: 2).background(Color("Dark-cian")).padding(.bottom)
                
                Button(action: verifyCode, label: {
                        Text("VERIFY")      .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(EdgeInsets(top: 11, leading: 18, bottom: 11, trailing: 18))
                            .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color("Dark-cian"), lineWidth: 1.0)
                                        .shadow(color:.white , radius: 6) )
                }).alert(isPresented: $isErrorField) {
                    Alert(title: Text("Error"), message: Text(messageError), dismissButton: .default(Text("OK")))
                    
                }
                
                Button(action: resendCode, label: {
                        Text("Resend Code")      .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(EdgeInsets(top: 11, leading: 18, bottom: 11, trailing: 18))
                            .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color("Dark-cian"), lineWidth: 1.0)
                                        .shadow(color:.white , radius: 6) )
                })
                
                
                if isLoading {
                    LoadingView()
                }
                Spacer()
            }.padding(40)
             
        }
        NavigationLink(
            destination: ContentView(),
            isActive: $isRegistrationView,
            label : {
                EmptyView()
            })
    }
    
    func onCommit() {
            print("commit")
        }
    func onEditingChanged(_ changed: Bool) {
            print(changed)
        }
    func verifyCode() {
        isLoading = true
        
        
        let dataUser = UserDefaults.standard.getUserData()
        guard let email =  dataUser?.user.email else {
            print("We have the email")
            return
        }
//        let loginSearc = LoginViewModel()
        LoginViewModel.validateCode(email: email, code: codeVery.text) { status, error in
            if status  {
                 
                isLoading = false

                return
            }
            
            if let error = error {
               
                messageError  = error
                isErrorField = true
            }
            
            isLoading = false
        }
    }
    
    func resendCode() {
        
        isLoading = true
        
        let dataUser = UserDefaults.standard.getUserData()
        guard let email =  dataUser?.user.email else {
            print("We have the email")
            return
        }
        
        UserDefaults.standard.setVeryCode(false)
        isRegistrationView = true
        LoginViewModel.resend_code(email: email) { status, error in
            if status  {
                isLoading = false
                return
            }
            if let error = error {
                messageError  = error
                isErrorField = true
            }
            
            isLoading = false
        }
    }
    
}

struct CodeVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        CodeVerifyView()
    }
}
 
