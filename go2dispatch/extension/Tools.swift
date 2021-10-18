//
//  Tools.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/28/21.
//

import Foundation
import SwiftUI
import UIKit

struct MyTextField: UIViewRepresentable {
    typealias UIViewType = UITextField

    @Binding var becomeFirstResponder: Bool

    func makeUIView(context: Context) -> UITextField {
        return UITextField()
    }
    
    func updateUIView(_ textField: UITextField, context: Context) {
        if self.becomeFirstResponder {
            DispatchQueue.main.async {
                textField.becomeFirstResponder()
                self.becomeFirstResponder = false
            }
        }
    }
}
 
