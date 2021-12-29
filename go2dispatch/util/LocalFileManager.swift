//
//  FileManager.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/26/21.
//

import SwiftUI
import Foundation
import UIKit
class LocalFileManager {
    
    static let instance = LocalFileManager() //singleton
    
    let folderName : String = "go2dispatch_files"
    
    init() {
        createFolderIfNeeded()
    }
     
    func createFolderIfNeeded() {
        guard let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
                    
                    return
                }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("⭐️ success creating the folder")
            } catch let error {
                    print("⭐️ Error creating folder. \(error)")
            }
        }
    }
    
    func deleteFolder() {
        guard let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
                    
                    return
                }
        do {
            try FileManager.default.removeItem(atPath: path)
            print("⭐️ Success deleting folder")
            
        } catch let error {
            print("⭐️ deleting folder errror \(error)")
        }
         
    }
    
    
    func saveImage(image : UIImage, name: String)   {
        
        guard let data =  image.jpegData(compressionQuality: 0.5),
        let path = getPathFromImage(name: name) else {
            print("⭐️ error getting data.")
            return
        }
        
        do {
            try data.write(to: path)
            print(path)
            print("⭐️ Success saving!")
            
        } catch let error {
            print("⭐️ Error saving \(error)")
            return 
        }
    }
    
    func deleteImage(name : String) {
        guard let path = getPathFromImage(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else {
                  print("⭐️ Error getting path.")
                  return
              }
        do {
            try FileManager.default.removeItem(atPath: path)
            print("⭐️ Successfully deleted")
        } catch let error {
            print("⭐️ Error delete file \(error)")
        }
    }
    
    func getImage(name: String) -> UIImage? {
        guard let path = getPathFromImage(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else {
                  print("⭐️ Error getting path.")
                  return nil
              }
                
        return UIImage(contentsOfFile: path)
                
    }
    
    func getPathFromImage(name : String) -> URL? {
        guard let
                path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathComponent("\(name).jpg") else {
                    return nil
                }
        print("⭐️ \(path)")
        return path
    }
    
}
