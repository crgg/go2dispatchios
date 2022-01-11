//
//  BlurView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/7/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    var style : UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
    
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

 