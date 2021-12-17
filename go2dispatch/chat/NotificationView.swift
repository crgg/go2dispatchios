//
//  NotificationView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/8/21.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var viewModel : ChatsViewModel
    
    var body: some View {
        VStack {
            Banner.init(data: Banner.BannerDataModel(title: viewModel.newMessageReceived.user_send, detail: viewModel.newMessageReceived.message, type: .info), show: $viewModel.isNewMessage )
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView().environmentObject(ChatsViewModel())
    }
}
