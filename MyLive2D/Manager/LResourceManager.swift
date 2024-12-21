//
//  LResourceManager.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/27.
//

import Foundation
import Combine

class LResourceManager {
    static var shared: LResourceManager = .init()
    
    var subfolder: String
    var rootURL: URL?
    
    private init() {
        subfolder = "Resources"
        
        do {
            if let fileManagerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "") {
                rootURL = fileManagerURL
            } else {
                rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                print("[MyLog]RootURL: \(rootURL?.description ?? "None")")
            }
        } catch {
            print("[MyLog]Error:\(error)")
        }
        
        startstartupActivities()
    }
    
    // Create Directories for project to store documents inside it
    func startstartupActivities() {
        createSubFolderDirectory()
    }
    
    // Create ./Documents/Resources
    func createSubFolderDirectory() {
        guard let url = rootURL else { return }
        
        let newURL = url.appending(path: subfolder, directoryHint: .isDirectory)
        
        if !FileManager.default.fileExists(atPath: newURL.path()) {
            do {
                try FileManager.default.createDirectory(at: newURL, withIntermediateDirectories: true)
            } catch {
                print("[MyLog]Error:\(error)")
            }
        }
    }
    
    func getBundleResoucesDir() -> URL? {
        guard let resourcePath = Bundle.main.resourcePath else { return nil }
        let resourcesDir = URL(fileURLWithPath: resourcePath).appending(path: MyLAppDefine.resourcesPath, directoryHint: .isDirectory)
//        print("[MyLog]resoucePath: \(resourcePath)")
//        print("[MyLog]bundlePath: \(resourcesDir)")
        
//        do{
//            let resourcesFiles = try FileManager.default.contentsOfDirectory(at: resourcesDir, includingPropertiesForKeys: nil)
//            print("[MyLog]resourcesDir....................")
//            dump(files)
//        }catch{
//            print("[MyLog]Error:\(error)")
//        }
        
        return resourcesDir
    }
    
    // Copy the documents at BundleURL to localURL synchronously
    func copyBundleResourcesToLocalDirectorySync(from sourceDir: URL) -> URL?{
        guard let url = rootURL else {
            return nil
        }
        
        do {
            var destinationDocumentsURL: URL = url
            
            destinationDocumentsURL = destinationDocumentsURL.appending(path: subfolder, directoryHint: .isDirectory)
            
            if FileManager.default.fileExists(atPath: destinationDocumentsURL.path()) {
                try FileManager.default.removeItem(at: destinationDocumentsURL)
            }
            
            print("[MyLog]sourceDir: \(sourceDir)")
            
            try FileManager.default.copyItem(at: sourceDir, to: destinationDocumentsURL)
            
            print("[MyLog]destinationDocumentsURL: \(destinationDocumentsURL.path())")
            
            print("[MyLog]FileManager.default.fileExists(atPath: destinationDocumentsURL.path()): \(FileManager.default.fileExists(atPath: destinationDocumentsURL.path()))")
            
            return destinationDocumentsURL
        } catch {
            print("[MyLog]Error:\(error)")
        }
        
        return nil
    }
    
    // Copy the documents at BundleURL to localURL asynchronously
    func copyBundleResourcesToLocalDirectoryAsync(from sourceDir: URL) async -> URL? {
        return await withCheckedContinuation { continuation in
            guard let url = rootURL else {
                continuation.resume(returning: nil)
                return
            }
            
            do {
                var destinationDocumentsURL: URL = url
                
                destinationDocumentsURL = destinationDocumentsURL.appending(path: subfolder, directoryHint: .isDirectory)
                
                if FileManager.default.fileExists(atPath: destinationDocumentsURL.path()) {
                    try FileManager.default.removeItem(at: destinationDocumentsURL)
                }
                
                print("[MyLog]sourceDir: \(sourceDir)")
                
                try FileManager.default.copyItem(at: sourceDir, to: destinationDocumentsURL)
                
                continuation.resume(returning: destinationDocumentsURL)
            } catch {
                print("[MyLog]Error:\(error)")
                continuation.resume(returning: nil)
            }
        }
    }
    
    // Copy the photo from PhotoLibrary to localURL
    
}
