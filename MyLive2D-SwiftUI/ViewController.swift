//
//  ViewController.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/22.
//

import Metal
import QuartzCore
import SwiftUI
import UIKit

class ViewController: UIViewController {
    private var commandQueue: MTLCommandQueue?
    private var depthTexture: MTLTexture?
    
    var myViewControllerBridge: My_ViewControllerBridge = .shared()
    
    var lResourceManager: LResourceManager = .shared
    
    let modelManager:ModelManager = .init()
    
    // MARK: ViewController Lifecycle Function
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        myViewControllerBridge.setToViewController(self)
        myViewControllerBridge.setToCommandQueue(commandQueue)
        myViewControllerBridge.setToDepthTexture(depthTexture)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        myViewControllerBridge.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.borderWidth = 2
        
        // Ensure ViewController Can be Touched
        view.isUserInteractionEnabled = true
        
        createContentViewController()
        
        createLARFaceTrackingViewController()
        
        print("[MyLog]UserDefaults.standard.bool(forKey: NOT_FIRST_RUN): \(UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))")
        
//        if !UserDefaults.standard.bool(forKey: NOT_FIRST_RUN){
        print("[MyLog]UserDefaults.standard.bool run")
        guard let bundleResourcesDir = lResourceManager.getBundleResoucesDir() else { return }
            
        let _ = lResourceManager.copyBundleResourcesToLocalDirectorySync(from: bundleResourcesDir)
//        }
        
        myViewControllerBridge.viewDidLoad()
        
        print("[MyLog]view Controller Start")
    }
}

// MARK: Implement MetalViewDelegate Protocol
extension ViewController: MetalViewDelegate{
    @objc func drawableResize(_ size: CGSize) {
//        print("[MyLog]drawableResize run")
        myViewControllerBridge.drawableResize(size)
    }
    
    @objc func renderToMetalLayer(_ metalLayer: CAMetalLayer) {
//        print("[MyLog]renderToMetalLayer run")
        myViewControllerBridge.renderToMetalLayer(metalLayer)
    }
}

extension ViewController {
    // MARK: - Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location: CGPoint = touch.location(in: view)
        print("[MyLog]Touch began at: \(location)")
        
        // TouchesBegan Event
        myViewControllerBridge.touchesBeganAt(x: location.x, y: location.y)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
        print("[MyLog]Touch moved to: \(location)")
        
        // Deal With TouchesMoved Event
        myViewControllerBridge.touchesMovedAt(x: location.x, y: location.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
        print("[MyLog]Touch ended at: \(location)")
        
        // Deal With TouchesEnded Event
        myViewControllerBridge.touchesEndedAt(x: location.x, y: location.y)
    }
    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("[MyLog]Touch cancelled")
//
//        // Deal With TouchesCancelled Event
//    }
}

extension ViewController {
    // MARK: Create Views
    // Create ContentView
    func createContentViewController() {
        // 创建 SwiftUI 视图
        let configurationView = ConfigurationView().environmentObject(modelManager)
               
        // 使用 UIHostingController 包装 SwiftUI 视图
        let hostingContentViewController = UIHostingController(rootView: configurationView)
               
        // 添加为子视图控制器
        addChild(hostingContentViewController)
        
        view.addSubview(hostingContentViewController.view)
        
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        
        hostingContentViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: 300,
            height: 300
        )
//        hostingContentViewController.view.backgroundColor = .yellow
        hostingContentViewController.view.layer.borderColor = UIColor.red.cgColor
        hostingContentViewController.view.layer.borderWidth = 2
        
        // 完成子视图控制器添加
        hostingContentViewController.didMove(toParent: self)
    }
    
    // Create ARFaceTrackingView
    func createLARFaceTrackingViewController() {
        let lARFaceTrackingView = LARFaceTrackingView().environmentObject(modelManager)
               
        let hostingLARFaceTrackingViewController = UIHostingController(rootView: lARFaceTrackingView)
               
        addChild(hostingLARFaceTrackingViewController)
        
        view.addSubview(hostingLARFaceTrackingViewController.view)
        
        hostingLARFaceTrackingViewController.view.frame = CGRect(
            x: 0,
            y: 300,
            width: 300,
            height: 300
        )
        
//        hostingLARFaceTrackingViewController.view.isHidden = true
        
        hostingLARFaceTrackingViewController.didMove(toParent: self)
    }
}
