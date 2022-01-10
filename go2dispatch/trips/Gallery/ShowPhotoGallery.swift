//
//  ShowPhotoGallery.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/6/22.
//

import SwiftUI

struct ShowPhotoGallery: View {
    @State var fotos : [fotos]
    @State var currentPost : Int = 0
    @State var fullPreview : Bool = false
    @State var freight : Freight
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        TabView(selection: $currentPost) {
            ForEach(fotos) {
                f in
                // For Getting Screen size for image...
                GeometryReader{
                    proxy in
                    let size  = proxy.size
                    DownloadingImageViewFreight(url: f.avatar, key: String(f.id), size: size)
                        
                    
                }
                .tag(f.id)
                .ignoresSafeArea()
                 
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation {
                fullPreview.toggle()
            }
        }
         // To DetailView
        .overlay(
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()    
                } label :{
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
                Text("Freight \(self.freight.BILL_NUMBER)")
                    .font(.title2.bold())
                Spacer(minLength: 0)
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                }
            }
                .foregroundColor(.white)
                .padding()
                .background(BlurView(style: .systemThinMaterialDark).ignoresSafeArea())
                .offset(y: fullPreview ? -150 : 0)
            ,
            alignment: .top
        )
        .overlay(
        
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing : 15) {
                        ForEach(fotos) {
                            fot  in
                            
                            DownloadingImageViewFreightSmall(url: fot.avatar, key: String(fot.id), currentPost : self.currentPost, id : fot.id)
                                .onTapGesture {
                                    withAnimation {
                                        currentPost = fot.id
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .frame(height: 80)
                .background(BlurView(style: .systemThinMaterialDark).ignoresSafeArea())
                .onChange(of: currentPost) { _ in
                    withAnimation{
                        proxy.scrollTo(currentPost, anchor: .bottom)
                    }
                }
            }
                .offset(y: fullPreview ? 150 : 0)
            ,
            alignment: .bottom
        
        )
        .onAppear {
            currentPost = fotos.first?.id ?? 0
        }
        
        
 
    }
    
}

struct ShowPhotoGallery_Previews: PreviewProvider {
    static var previews: some View {
        ShowPhotoGallery(fotos: TripList.sampleTrips[0].freights[0].fotos, freight: TripList.sampleTrips[0].freights[0])
        
    }
}

struct DownloadingImageViewFreightSmall: View {
    @StateObject var loader : ImageLoadingViewModel
    var imagePerfil : UIImage =  UIImage(named: "noimg")!
    var currentPost : Int
    var id : Int
    
    init(url: String, key : String, currentPost : Int, id: Int) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
        self.id = id
        self.currentPost = currentPost
        
    }
    
    var body: some View {
        
        
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else  if let image = loader.image {
                 Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode : .fill)
                    .frame(width: 70  ,   height: 60)
                    .cornerRadius(12)
                // Showing Ring for current
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.white, lineWidth: 2)
                            .opacity(currentPost == id ? 1 : 0)
                    )
                    .id(id)
                     
            } else {
                Image(uiImage: imagePerfil)
                    .resizable()
                    .aspectRatio(contentMode : .fill)
                    .frame(width: 70  ,   height: 60)
                    .cornerRadius(12)
                    
            }
        }
    }
}

struct DownloadingImageViewFreight: View {
    @StateObject var loader : ImageLoadingViewModel
    var imagePerfil : UIImage =  UIImage(named: "noimg")!
    var size: CGSize
    init(url: String, key : String, size : CGSize) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
        self.size = size
        
        
    }
    
    var body: some View {
        
        
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else  if let image = loader.image {
                 Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode : .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(0)
                     
            } else {
                Image(uiImage: imagePerfil)
                    .resizable()
                    
            }
        }
    }
}
