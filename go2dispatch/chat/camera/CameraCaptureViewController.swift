//
//  CameraCaptureViewController.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/23/21.
//


import UIKit
import AVFoundation
import CoreImage
import SwiftUI
class CameraCaptureViewController: UIViewController {
    // Capture Session
    var session : AVCaptureSession?
    // Photo Output
    var output =  AVCapturePhotoOutput()
    // video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // Shutter
    public var chat : Chat 
  
    
    
    var vm : ChatsViewModel
    
    
    private let shutterButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let buttonClose : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        
//        button.layer.cornerRadius = 50
//        button.layer.borderWidth = 10
//        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    private let buttongallery : UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 50, height: 50))
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        
        //        button.layer.cornerRadius = 50
        //        button.layer.borderWidth = 10
                button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    init(vm : ChatsViewModel, chat: Chat) {
        self.vm = vm
        self.chat = chat
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
  
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(buttonClose)
        view.addSubview(buttongallery)
        checkCameraPermissions()
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        buttonClose.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        buttongallery.addTarget(self, action: #selector(galleryButton), for: .touchUpInside)
    }
    
    @objc func galleryButton() {
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .photoLibrary
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
        buttongallery.center = CGPoint(x: 50, y: view.frame.size.height - 100)
    }
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
                
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
        
    }
    
    func setUpCamera() {
        let session =  AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                session.startRunning()
                self.session = session
                
            }
            catch {
                print(error)
            }
        }
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension CameraCaptureViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          
      }

      public func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
          guard let imagen_capture = info[.originalImage] as? UIImage else {
              return
          }
      
//          let imagenReduce : UIImage = self.resizeImage(image:  imagen_capture, targetSize: CGSize(width:  imagen_capture.size.width / 2 , height: imagen_capture.size.height / 2  ))
//
          
              vm.didSelectImage(imagen_capture, chat: chat)
          
          
          
          picker.dismiss(animated: true, completion: nil)
          
          closeView()
          
          
         
}
    
    // reduce la imagen
    func resizeImage ( image: UIImage, targetSize: CGSize) -> UIImage {
       
        let size = image.size
        
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        
        if (widthRatio > heightRatio) {
        
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        
        } else {

            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    
    }
}
extension CameraCaptureViewController: UINavigationControllerDelegate {

}

extension CameraCaptureViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
         
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode =  .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
     
    }
    
 
}
