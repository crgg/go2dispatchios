//
//  go2dispatchApp.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/2/21.
//

import SwiftUI

@main
struct go2dispatchApp: App {
    @Environment (\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) private var appDelegate

    init() {
        // inicio de vida de la app es cuando la application se inicia
        print("inicia la app")
    
    }
    var body: some Scene {
        WindowGroup {
         
            let veryCode = UserDefaults.standard.getVeryCode()
            if veryCode {
                CodeVerifyView()
            } else {
//             ContentView()
                ChatRooms()
            }
        }.onChange(of: scenePhase) { phase in
            print(phase)
            // Cycle the life the application
         // active
         // inactive ejemplo : musica stop reproductor de musica
         // background
            if phase == .inactive {
                print("la app esta inactiva, guardare los datos para despues continuar fluidamente")
            }
            
        }
    }
}
