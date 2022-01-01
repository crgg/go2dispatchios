//
//  DownloadingImageView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/27/21.
//

import SwiftUI

struct DownloadingImageView: View {
    @StateObject var loader : ImageLoadingViewModel
    var imagePerfil : UIImage =  UIImage(named: "noimg")!
    init(url: String, key : String) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
        
        
    }
    
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else  if let image = loader.image {
                 Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
            } else {
                Image(uiImage: imagePerfil)
                    .resizable()
                    .clipShape(Circle())
            }
        }
    }
}

struct DownloadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImageView(url: "https://via.placeholder.com/600/92c952", key:  "1")
            .frame(width: 70, height: 70)
            .previewLayout(.sizeThatFits)
    }
}
