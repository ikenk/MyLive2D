//
//  LDocumentPicker.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/27.
//

import SwiftUI

struct LDocumentPicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let docPickerController = UIDocumentPickerViewController()
        docPickerController.allowsMultipleSelection = false
        docPickerController.shouldShowFileExtensions = true
        docPickerController.delegate = context.coordinator
        
        return docPickerController
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        DocumentPickerCoordinator()
    }
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    
}
