//
//  EditProfileView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/26/21.
//

import SwiftUI
struct moduloEditar  :View {
    @State var correo : String = ""
    @State var password : String = ""
    @State var name : String  = ""
    
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing : 15) {
            
            Text("Email").foregroundColor(Color("Dark-cian"))
            ZStack(alignment : .leading) {
                if correo.isEmpty {
                    Text("sample@gotologistics.net").font(.caption)
                        .foregroundColor(Color(red: 174/255, green: 177/255, blue: 185/255, opacity: 1.0))
                }
                
                TextField("", text : $correo).foregroundColor(.white)
                
                
            }
            Divider().frame(height : 1.0)
                .background(Color("Dark-Cian"))
            // pass
            Text("Password").foregroundColor(.white)
            
            ZStack(alignment : .leading) {
                if password.isEmpty {
                    Text("Enter the password").font(.caption)
                        .foregroundColor(.white)
                }
                
                SecureField("", text : $password).foregroundColor(.white)
                
                
            }
            Divider().frame(height : 1.0)
                .background(Color(.white))
            
            // namme
//            Text("Name").foregroundColor(.white)
//
//            ZStack(alignment : .leading) {
//                if name.isEmpty {
//                    Text("Enter the name").font(.caption)
//                        .foregroundColor(.white)
//                }
//
//                TextField("", text : $name).foregroundColor(.white)
//
//
//            }
//            Divider().frame(height : 1.0)
//                .background(Color(.white)).padding(.bottom, 32)
            
            Button(action: { updateData() }, label: {
                Text("Update")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(EdgeInsets(top: 11, leading: 18, bottom: 11, trailing: 18))
                    .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color("Dark-cian"), lineWidth: 1.0)
                                .shadow(color:.white , radius: 6) )
                
                // infinity : cresca lo necesario
            })
            
            
        }.padding(.horizontal, 42.0)
        .onAppear(
            perform: {
               getUserInfo()
            })
    }
    
    func updateData() {
        
        let objectUpdate = SaveData()
        let resultado = objectUpdate.save(corre: correo, password: password, name: name)
        print("Se guardaron los datos successly \(resultado)")
    }
    
    func getUserInfo() {
        
    }
    
    
}


struct EditProfileView: View {
    
    @State var imageperfil : Image? = Image("profile_sample")
    @State var isCameraActive = false
    
    
    var body: some View {
        
            ZStack {
                
                
                
                Color("Marine").ignoresSafeArea()
                VStack {
                    Text("Edit Perfil").foregroundColor(.white).font(.title2)
                ScrollView {
                    
                    // foto de perfil
                    VStack {
                        
                        
                        
                        Button(action:  {
                            isCameraActive = true
                             
                        }, label: {
                            ZStack {
                                
                                imageperfil!
                                    .resizable().aspectRatio(contentMode: .fill).frame(width: 118.0, height: 118.0)
                                    .clipShape(Circle())
                                    .sheet(isPresented: $isCameraActive, content: {
                                        SUImagePickerView(sourceType: .camera, image: self.$imageperfil, isPresented: $isCameraActive)

                                    })
                                
                                Image(systemName: "camera").foregroundColor(.white)
                            }
                            
                        })
                        
                    }.padding(.bottom, 18.0)
                    // module editar
                    moduloEditar()
                    
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
