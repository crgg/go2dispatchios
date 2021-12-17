//
//  UserStateViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/10/21.
//

import Foundation

enum UserStateError: Error{
    case signInError, signOutError
}
class UserStateViewModel : ObservableObject {
    @Published var isLoggedIn = false
    @Published var isBusy = false
    
    func signIn() {
        DispatchQueue.main.async {
            self.isLoggedIn =  true
            self.isBusy = false
        }
        
    }
    func signOut() {
        DispatchQueue.main.async {
            UserDefaults.standard.setLoggedIn(false)
            UserDefaults.standard.setUserData(nil)
            self.isLoggedIn =  false
            self.isBusy = false
        }
    }
}

