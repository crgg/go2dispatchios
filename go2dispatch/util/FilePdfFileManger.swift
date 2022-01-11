//
//  FilePdfFileManger.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/10/22.
//

import Foundation
import PDFKit

class FilePdfFileManager {
    static let instance = FilePdfFileManager()
     let folderName : String = "go2dispatch_files"
    private init() {
        createFolderIfNeeded()
    }
     func createFolderIfNeeded() {
         guard let url = getFolderPath() else { return }
         if !FileManager.default.fileExists(atPath: url.path) {
             do {
                 try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                 print("create folder")
                 
             } catch let error {
                 print("error create folde \(error)")
             }
         }
     }
     
     
     func getFolderPath() -> URL? {
         return FileManager
             .default
             .urls(for: .cachesDirectory, in: .userDomainMask)
             .first?
             .appendingPathComponent(folderName)
     }
     
     func getImagePath(key: String) -> URL? {
         guard let
                 path = FileManager
                 .default
                 .urls(for: .cachesDirectory, in: .userDomainMask)
                 .first?
                 .appendingPathComponent(folderName)
                 .appendingPathComponent("\(key).pdf") else {
                     return nil
                 }
         print("⭐️ \(path)")
         return path
     }
     
     func add(key: String, value : UIImage) {
         
         guard let data  = value.jpegData(compressionQuality: 0.5),
         let url  = getImagePath(key: key)  else {
             return
         }
         
         do {
             try data.write(to: url)
         } catch let error {
             print("Error add image \(error)")
         }
     }
     
     func get(key: String) -> UIImage? {
         guard let path = getImagePath(key: key)?.path,
               FileManager.default.fileExists(atPath: path) else {
                   print("⭐️ Error getting path.")
                   return nil
               }
                 
         return UIImage(contentsOfFile: path)    }
     
     
    
}
