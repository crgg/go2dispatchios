//
//  TextFieldManager.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/28/21.
//

import Foundation

class TextFieldManager : ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
            
            let filtered = text.filter { $0.isNumber }
            if text != filtered {
                text =  filtered
            }
            
            
        }
    }
    let characterLimit: Int
    
    init(limit: Int = 6){
        characterLimit = limit
    }
}
