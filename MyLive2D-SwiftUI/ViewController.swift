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
    
//    var myModelRender:My_ModelRender?
    
    var myViewControllerBridge: My_ViewControllerBridge = .shared()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
//        myModelRender = .init(viewController: self, commandQueue: self.commandQueue, depthTexture: self.depthTexture)
        myViewControllerBridge.setToViewController(self)
        myViewControllerBridge.setToCommandQueue(commandQueue)
        myViewControllerBridge.setToDepthTexture(depthTexture)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
//        super.init(nibName: nil, bundle: nil)
//        myModelRender = .init(viewController: self)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
//        let metalUIView = MetalUIView()
//        self.view = metalUIView
//        guard let myModelRender = myModelRender else { print("No myModelRender!!!"); return }
//        myModelRender.loadView()
        myViewControllerBridge.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建 SwiftUI 视图
        let contentView = ContentView()
               
        // 使用 UIHostingController 包装 SwiftUI 视图
        let hostingController = UIHostingController(rootView: contentView)
               
        // 添加为子视图控制器
        addChild(hostingController)
        
        view.addSubview(hostingController.view)
        
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        
//        let _ = print(view.frame.size)
        
        hostingController.view.frame = CGRect(
            x: 50,
            y: 50,
            width: 200,
            height: 200
        )
        hostingController.view.backgroundColor = .yellow
        
        // 完成子视图控制器添加
        hostingController.didMove(toParent: self)
        
//        guard let myModelRender = myModelRender else { print("No myModelRender!!!"); return }
        
//        myModelRender.viewDidLoad()
        
        myViewControllerBridge.viewDidLoad()
        
        print("view Controller Start")
    }

    // 实现 MetalViewDelegate 协议
    @objc func drawableResize(_ size: CGSize) {
//        guard let myModelRender = myModelRender else { print("No myModelRender!!!"); return }
//        myModelRender.drawableResize(size)
        myViewControllerBridge.drawableResize(size)
    }
    
//    @objc(renderToMetalLayer:)
//    func render(to layer: CAMetalLayer) {
//        // 实现renderToMetalLayer...
//    }
    @objc func renderToMetalLayer(_ metalLayer: CAMetalLayer) {
//        dump(metalLayer.nextDrawable())
//        guard let myModelRender = myModelRender else { print("No myModelRender!!!"); return }
//        myModelRender.renderToMetalLayer(metalLayer)
        myViewControllerBridge.renderToMetalLayer(metalLayer)
    }
}
