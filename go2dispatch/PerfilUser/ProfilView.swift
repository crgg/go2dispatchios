//

//  ProfilView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import SwiftUI


struct moduleAjuste : View {
    @State var isToggleOn =  true
    @State var isEditProfileViewActive  = false
    @State var isLogOut =  false
    @EnvironmentObject var vm: UserStateViewModel
    var body: some View {
        
        
            VStack(spacing: 3) {
                
                //            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                //
                //
                //                HStack {
                //
                //                    Text("Account").foregroundColor(.white)
                //                    Spacer()
                //                    Text(">").foregroundColor(.white)
                //
                //                }.padding()
                //
                //            })
                //              .background(Color("Blue-Gray"))
                //            .clipShape(RoundedRectangle(cornerRadius: 1.0))
                
                //            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                //
                //
                //                HStack {
                //                    Text("Notificationes").foregroundColor(.white)
                //                    Spacer()
                //                    Toggle("",isOn: $isToggleOn)
                //
                //                }.padding()
                //
                //            })
                //              .background(Color("Blue-Gray"))
                //            .clipShape(RoundedRectangle(cornerRadius: 1.0))
                
                Button(action: {
                    isEditProfileViewActive = true
                    
                }
                       , label: {
                    
                    
                    HStack {
                        
                        Text("Edit Account ").foregroundColor(.white)
                        Spacer()
                        Text(">").foregroundColor(.white)
                        
                    }.padding()
                    
                })
                    .background(Color("Blue-Gray"))
                    .clipShape(RoundedRectangle(cornerRadius: 1.0))
                
                Button(action: logout, label: {
                    
                    
                    HStack {
                        
                        Text("Log out").foregroundColor(.white)
                        Spacer()
                        Text(">").foregroundColor(.white)
                        
                    }.padding()
                    
                })
                    .background(Color("Blue-Gray"))
                    .clipShape(RoundedRectangle(cornerRadius: 1.0))
//                    .fullScreenCover(isPresented: $isLogOut) {
//                        ContentView()
//                    }
                
                NavigationLink(
                    destination: EditProfileView(),
                    isActive : $isEditProfileViewActive,
                    label: {
                        EmptyView()
                    })
            }
        
//            .fullScreenCover(isPresented: $isEditProfileViewActive, onDismiss: nil) {
//                EditProfileView().ignoresSafeArea()
//            }
    }
    func logout() {
     
        vm.signOut()
    }
}

struct ProfilView: View {
    @State var nameUser : String  = "Paulette Gajardo"
    @State var imagePerfil : UIImage =  UIImage(named: "profile_sample")!
    
    var body: some View {
        NavigationView {
        ZStack {
            Color("Marine").ignoresSafeArea()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            VStack {
                
                Text("Profile").fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .center).padding()
                    
                    
                VStack {
                    Image(uiImage: imagePerfil).resizable().aspectRatio(contentMode: .fill).frame(width: 118.0, height: 118.0)
                        .clipShape(Circle())
                    
                }.padding(EdgeInsets(top: 8 , leading: 0, bottom: 15, trailing: 0))
                
                Text(nameUser).foregroundColor(.white)
                    .padding(.bottom, 32)
                
                
                Text("Account")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading).padding(.leading, 18)
                    .padding(.bottom, 16)
                
                moduleAjuste()
                Spacer()
            }
        }.onAppear(
            perform: {
                // imagen
                if let imagePe =  returnUiImage(named: "photo_perfil.png") {
                    imagePerfil = imagePe
                } else {
                    print("no found photo the perfil")
                }
                
                print("information")
                if let userName =  UserDefaults.standard.getUserName() {
                        self.nameUser = userName
                }
            }
        ).onDisappear(
            perform: {
                print("Disapper the vista")
            }
        )
        }.navigationTitle("")
            .navigationBarHidden(true)
    }
    
    func returnUiImage(named : String) -> UIImage? {
        let locaFileM = LocalFileManager.instance
    
        return locaFileM.getImage(name: "profile_sample")
        
//        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
//            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
//        }
//        return nil
        
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
