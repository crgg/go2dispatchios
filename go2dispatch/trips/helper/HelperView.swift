//
//  HelperView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/6/22.
//

import SwiftUI

struct TextTripView : View {
    var texto : String  = ""
    let colorFont : Color
    var body: some View {
        Text(texto)
            .foregroundColor(colorFont)
            .font(.caption)
    }
    
    
}
struct IconTripView : View {
    let widthIcon : CGFloat = 20
    let heightIcon : CGFloat = 10
    let colorFont: Color
    let img : String
    var body: some View {
        Image(img)
            .resizable()
            .frame(width: widthIcon, height: heightIcon)
            .foregroundColor(colorFont)
    }
    
}
