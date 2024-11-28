//
//  LocalDocHandler.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/27.
//

import Foundation

class LocalDocHandler {
    var subfolder: String
    var rootURL: URL?
    
    init() {
        subfolder = "Resources"
        
        do {
            if let fileManagerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "") {
                rootURL = fileManagerURL
            } else {
                rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                print("RootURL: \(rootURL?.description ?? "None")")
            }
        } catch {
            print(error)
        }
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
                print(error)
            }
        }
    }
    
    // FIXME: wheather use this func
    // Create ./Documents/Resources/<Resource name>
    func createResourceInsideDocumentsDirectory(at resource: String) {
        do {
            guard let url = rootURL else {
                return
            }
            let iCloudDocumentsURL = url
                .appendingPathComponent(subfolder, isDirectory: true)
                .appendingPathComponent(resource, isDirectory: true)
            if !FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: nil) {
                try FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print(error)
        }
    }
}
