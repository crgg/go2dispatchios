//
//  go2dispatchApp.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/2/21.
//

import SwiftUI
import CoreData
@main
struct go2dispatchApp: App {
    @Environment (\.scenePhase) var scenePhase
    let persistenceContainer = PersistenceController.shared 
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) private var appDelegate
    @StateObject var userStateViewModel = UserStateViewModel()
    
    
    init() {
        // inicio de vida de la app es cuando la application se inicia
        print("inicia la app")
    
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ApplicationSwitcher()
            }.navigationViewStyle(.stack)
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
                .environmentObject(userStateViewModel)
          
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


struct ApplicationSwitcher : View {
    
    @EnvironmentObject var vm: UserStateViewModel
    
    let persistenceContainer = PersistenceController.shared
    var body: some View {
        let veryCode = UserDefaults.standard.getVeryCode()
        if veryCode {
            CodeVerifyView().environment(\.managedObjectContext, persistenceContainer.container.viewContext) // <- and here <-

        } else {
            
            if UserDefaults.standard.getLoggedIn() || vm.isLoggedIn {
                Home().environment(\.managedObjectContext, persistenceContainer.container.viewContext) // <- and here <-

                 
            } else {
                  ContentView().environment(\.managedObjectContext, persistenceContainer.container.viewContext) // <- and here <-

            }
//                ChatRooms()
//                TimeClockView()
        }
    }
    
}
