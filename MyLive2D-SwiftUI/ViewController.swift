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
    
    private var myModelRender:My_ModelRender?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        myModelRender = .init(viewController: self)
    }
    
    required init?(coder: NSCoder) {
//        super.init(nibName: nil, bundle: nil)
//        myModelRender = .init(viewController: self)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
//        let metalUIView = MetalUIView()
//        self.view = metalUIView
        guard let myModelRender = myModelRender else { print("No myModelRender!!!"); return }
        myModelRender.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置Metal渲染相关...
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        
        // 创建 SwiftUI 视图
        let contentView = ContentView()
               
        // 使用 UIHostingController 包装 SwiftUI 视图
        let hostingController = UIHostingController(rootView: contentView)
               
        // 添加为子视图控制器
        self.addChild(hostingController)
        
        view.addSubview(hostingController.view)
        
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        
        let _ = print(view.frame.size)
        
        hostingController.view.frame = CGRect(
            x: 50,
            y: 50,
            width: 200,
            height: 200
        )
        hostingController.view.backgroundColor = .yellow
        
        // 完成子视图控制器添加
        hostingController.didMove(toParent: self)
        
        guard let myModelRender = myModelRender else { print("No myModelRender!!!"); return }
        myModelRender.loadView()
              
//        let single = CubismRenderingInstanceSingleton_Metal.shared()
//        single?.setMTLDevice(device)
//
//        guard let metalView = self.view as? MetalUIView else { return }
//        metalView.metalLayer.device = device
//        metalView.delegate = self
//        metalView.metalLayer.pixelFormat = .bgra8Unorm
//
//        single?.setMetalLayer(metalView.metalLayer)
//
//        commandQueue = device.makeCommandQueue()
//
//        // 初始化触摸管理
//        touchManager = TouchManager()
//
//        // 初始化矩阵
//        deviceToScreen = CubismMatrix44.new()
//        viewMatrix = CubismViewMatrix.new()
//
//        initializeScreen()
    }

    // 实现 MetalViewDelegate 协议
    @objc func drawableResize(_ size: CGSize) {
        // 实现drawableResize...
    }
    
//    @objc(renderToMetalLayer:)
//    func render(to layer: CAMetalLayer) {
//        // 实现renderToMetalLayer...
//    }
    @objc func renderToMetalLayer(_ metalLayer: CAMetalLayer) {
        
    }
}
