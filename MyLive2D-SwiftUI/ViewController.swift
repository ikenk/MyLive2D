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

class ViewController: UIViewController, MetalViewDelegate {
    private var commandQueue: MTLCommandQueue?
    private var depthTexture: MTLTexture?
    
    var myViewControllerBridge: My_ViewControllerBridge = .shared()
    
    var lResourceManager: LResourceManager = .shared
    
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
        
//        let _ = print("UIScreen.main.bounds :\(UIScreen.main.bounds)")
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.borderWidth = 2
        
        createContentViewController()
        
//        createLARFaceTrackingViewController()
        
        guard let bundleResourcesDir = lResourceManager.getBundleResoucesDir() else { return }

        let _ = lResourceManager.copyBundleResourcesToLocalDirectorySync(from: bundleResourcesDir)
        
        myViewControllerBridge.viewDidLoad()
        
        print("view Controller Start")
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        guard let bundleResourcesDir = lResourceManager.getBundleResoucesDir() else { return }
//        
//        Task{
//            let _ = await lResourceManager.copyBundleResourcesToLocalDirectoryAsync(from: bundleResourcesDir)
//        }
//    }

    // 实现 MetalViewDelegate 协议
    @objc func drawableResize(_ size: CGSize) {
        myViewControllerBridge.drawableResize(size)
    }
    
    @objc func renderToMetalLayer(_ metalLayer: CAMetalLayer) {
        myViewControllerBridge.renderToMetalLayer(metalLayer)
    }
}

extension ViewController {
    func createContentViewController() {
        // 创建 SwiftUI 视图
        let contentView = ContentView()
               
        // 使用 UIHostingController 包装 SwiftUI 视图
        let hostingContentViewController = UIHostingController(rootView: contentView)
               
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
    
    func createLARFaceTrackingViewController() {
        let lARFaceTrackingView = LARFaceTrackingView()
               
        let hostingLARFaceTrackingViewController = UIHostingController(rootView: lARFaceTrackingView)
               
        addChild(hostingLARFaceTrackingViewController)
        
        view.addSubview(hostingLARFaceTrackingViewController.view)
        
        hostingLARFaceTrackingViewController.view.frame = CGRect(
            x: 0,
            y: 300,
            width: 500,
            height: 500
        )
        
        hostingLARFaceTrackingViewController.didMove(toParent: self)
    }
}
