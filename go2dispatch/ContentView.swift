//
//  ContentView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/2/21.
//

import SwiftUI
import iPhoneNumberField
struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 18/255, green: 32/255, blue: 61/255, opacity: 1.0).ignoresSafeArea()
                VStack {
                    Image("app_logo").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:80, height: 80, alignment: .top)
                        .padding(.bottom, 22)
                    startAndRegister()
                }
            }.navigationBarHidden(true)
            
            // esto es para los ipad
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct startAndRegister : View {
    @State var startSession = true
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Log in") {
                    startSession = true
                }.foregroundColor(startSession ? .white : .gray)
                Spacer()
                Button("Register") {
                    startSession = false
                }.foregroundColor(startSession ? .gray : .white)
                Spacer()
            }
            Spacer(minLength: 42)
            if startSession ==  true {
                LoginView()
            } else {
                registerView()
            }
        }
    }
}

struct registerView: View {
    @State var isLoading = false
    @State var email = "adtest@gmail.com"
    @State var password = "Ramon!234@"
    @State var password_confirmation = "Ramon!234@"
    @State var isErrorField = false
    @State var messageError = ""
    @State var phone_number = "6308739321"
    @State var isActiveCodeVerify = false
    var body: some View {
        ScrollView {
//            VStack (alignment: .center) {
//                Text("Choice a profile Profile").fontWeight(.bold).foregroundColor(.white)
//                Text("Can change after")
//                    .font(.footnote)
//                    .fontWeight(.light)
//                    .foregroundColor(.gray)
//                    .padding(.bottom)
//
//                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                    ZStack {
//                        Image("profile_sample").resizable().aspectRatio(contentMode: .fit).frame(width: 80, height: 80)
//                        Image(systemName: "camera").foregroundColor(.white)
//                    }.padding(.bottom)
//
//
//
//                })
//            }
            
            
            VStack(alignment: .leading) {
                // email
                Text("Email*").foregroundColor(.white)
 
                    let binding = Binding<String>(get: {
                               self.email
                           }, set: {
                               self.email = $0.lowercased()
                           })
                    
                    TextField("", text : binding).foregroundColor(.white)
                        .placeholder(when: email.isEmpty) {
                                Text("sample@gotologistics.net")
                               .font(.caption)
                               .foregroundColor(.gray)
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
                //password
                Text("Confirmation").foregroundColor(.white)
                
                ZStack (alignment: .leading) {
                    
                        if password_confirmation.isEmpty {
                            Text("Confirmation Pasword")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    SecureField("", text : $password_confirmation).foregroundColor(.white)
                }
              
                
                Divider().frame(height: 2).background(Color("Dark-cian")).padding(.bottom)
             
                
               
              
            } // end vstack after scrollview
            
            VStack (alignment: .leading) {
                Text("Phone number").foregroundColor(Color.white)
                iPhoneNumberField("",text: $phone_number)
                    .font(UIFont(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .maximumDigits(10)
                    .placeholder(when: phone_number.isEmpty) {
                            Text("(000) 000-0000")
                           .font(.caption)
                           .foregroundColor(.gray)
                    }
                Divider().frame(height: 2).background(Color("Dark-cian")).padding(.bottom)

            }
            
            
            if isLoading {
                LoadingView()
            }
            
            Button(action: registrate, label: {
                Text("Register")
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
            
//            bottones()
              
        }.padding(.horizontal, 50.0) // end Scrolview
        
        NavigationLink(
            destination: CodeVerifyView(),
            isActive: $isActiveCodeVerify,
            label : {
                EmptyView()
            })
    }
    
     
    func registrate() {
        
        
        guard !email.isBlank else {
            isErrorField = true
            messageError = "Must Enter a email "
            return
        }
        guard email.isEmail else {
            isErrorField = true
            messageError = "Email is badly formatted"
            return
        }
        
        
        guard !password.isBlank else {
            isErrorField = true
            messageError = "Must Enter a password"
            return
        }
        
        guard password.isValidPasswor else {
            // least one uppercase,
            // least one digit
            // least one lowercase
            // least one symbol
            //  min 8 characters total
            isErrorField = true
            messageError = "Password least one uppercase, \n least one digit \n least one lowercase            \n least one symbol \n min 8 characters total"
            return
        }
        
        guard password == password_confirmation else {
            isErrorField = true
            messageError = "Password no match"
            return
        }
        guard !phone_number.isEmpty else {
            isErrorField = true
            messageError = "Must Phone number"
            return
        }
        
        
        let phoneD =  String(phone_number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        isLoading = true
        
        LoginViewModel.registration_sms(email: email, password: password, phone_number: phoneD, Image: nil) { status_request, error in
            if let error = error {
                isLoading = false
                isErrorField = true
                messageError = error
                return
            }
            
            UserDefaults.standard.setVeryCode(true)
            isLoading = false
            
//              let da =  startAndRegister.init(startSession: true)
            isActiveCodeVerify = true
            
        }
        
       
    }
}


struct bottones : View {
    var body: some View {
       
        //            .frame(width: .infinity , height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        Text("Start Social media").foregroundColor(.white)
            .frame(maxWidth:.infinity, alignment: .center).padding(.top, 20)
            
            
            
        
                    Spacer()
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            Text("Facebook")
                        }.foregroundColor(.white)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center )
                        .padding(.vertical, 10.0)
                        .background(Color(.blue))
                        .clipShape(RoundedRectangle(cornerRadius: 10.5)).padding()
                    
//                        .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(.blue))



                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            Text("Twitter")
                        }.foregroundColor(.white)
                        .font(.caption)
                        .frame(maxWidth: .infinity,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(.vertical, 10.0)
                        .background(Color(.blue))
                        .clipShape(RoundedRectangle(cornerRadius: 10.5)).padding()
                    }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
