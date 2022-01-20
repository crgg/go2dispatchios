//
//  CircleButtonView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/17/22.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName : String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 30, height: 30)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "arrow.left")
            .previewLayout(.sizeThatFits)
            CircleButtonView(iconName: "arrow.left")
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
        }
    }
}
