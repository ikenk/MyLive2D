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
import Combine

class ViewController: UIViewController {
    private var commandQueue: MTLCommandQueue?
    private var depthTexture: MTLTexture?
    
    var myViewControllerBridge: My_ViewControllerBridge = .shared()
    
    var lResourceManager: LResourceManager = .shared
    
    let modelManager: LModelManager = .init()
    
    let viewManager: LViewManager = .init()
    
    var cancellables = Set<AnyCancellable>()
    
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
        
        createLConfigurationViewController()
        
        createLARFaceTrackingViewController()
        
        createLInfoButton()
        
        print("[MyLog]UserDefaults.standard.bool(forKey: NOT_FIRST_RUN): \(UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))")
        
//        if !UserDefaults.standard.bool(forKey: NOT_FIRST_RUN){
        print("[MyLog]UserDefaults.standard.bool run")
        guard let bundleResourcesDir = lResourceManager.getBundleResoucesDir() else { return }
            
        let _ = lResourceManager.copyBundleResourcesToLocalDirectorySync(from: bundleResourcesDir)
//        }
        
        myViewControllerBridge.viewDidLoad()
        
        print("[MyLog]view Controller Start")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaInsets = view.safeAreaInsets
        print("[MyLog]SafeArea Top: \(safeAreaInsets.top) and Bottom: \(safeAreaInsets.bottom)")
        print("[MyLog]SafeArea Top: \(safeAreaInsets.top) and Bottom: \(safeAreaInsets.bottom)")
    }
}

// MARK: Implement MetalViewDelegate Protocol

extension ViewController: MetalViewDelegate {
    @objc func drawableResize(_ size: CGSize) {
        print("[MyLog]drawableResize run")
        myViewControllerBridge.drawableResize(size)
    }
    
    @objc func renderToMetalLayer(_ metalLayer: CAMetalLayer) {
//        print("[MyLog]renderToMetalLayer run")
        myViewControllerBridge.renderToMetalLayer(metalLayer)
    }
}

// MARK: - Touch Events

extension ViewController {
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

// MARK: Create Views

extension ViewController {
    // MARK: Create ConfigurationView
    
    func createLInfoButton() {
        let lInfoButton = LInfoButton().environmentObject(viewManager)
        
        let hostingLInfoButton = UIHostingController(rootView: lInfoButton)
        
        addChild(hostingLInfoButton)
        
        view.addSubview(hostingLInfoButton.view)
        
        // Auto Layout
        hostingLInfoButton.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingLInfoButton.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            hostingLInfoButton.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            hostingLInfoButton.view.widthAnchor.constraint(equalToConstant: 30),
            hostingLInfoButton.view.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        // Frame Layout
//        hostingLInfoButton.view.frame = CGRect(x: UIScreen.main.bounds.maxX - 30, y: UIScreen.main.bounds.minY + 50 , width: 20, height: 20)
        
        hostingLInfoButton.view.backgroundColor = .clear
//        hostingLInfoButton.view.layer.borderColor = UIColor.green.cgColor
//        hostingLInfoButton.view.layer.borderWidth = 2
        
        hostingLInfoButton.didMove(toParent: self)
        
//        view.bringSubviewToFront(hostingLInfoButton.view)
    }
    
    // MARK: Create ConfigurationView

    func createLConfigurationViewController() {
        // 创建 SwiftUI 视图
        let lConfigurationView = LConfigurationView().environmentObject(modelManager).environmentObject(viewManager)
               
        // 使用 UIHostingController 包装 SwiftUI 视图
        let hostingLConfigurationViewController = UIHostingController(rootView: lConfigurationView)
               
        // 添加为子视图控制器
        addChild(hostingLConfigurationViewController)
        
        view.addSubview(hostingLConfigurationViewController.view)
        
        // Auto Layout
        hostingLConfigurationViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
//        ])
        if UIDevice.current.userInterfaceIdiom == .pad{
            NSLayoutConstraint.activate([
                hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5),
                hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5),
            ])
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if view.frame.width > view.frame.height{
                NSLayoutConstraint.activate([
                    hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 40),
                    hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
                    hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -25)
                ])
            } else {
                NSLayoutConstraint.activate([
                    hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
                    hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1)
                ])
            }
        }
        
        // Frame Layout
//        hostingLContentViewController.view.frame = CGRect(
//            x: 0,
//            y: 0,
//            width: 300,
//            height: UIScreen.main.bounds.height / 2 - 10
//        )
//        hostingLConfigurationViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        hostingLConfigurationViewController.view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
//        hostingLConfigurationViewController.view.layer.borderColor = UIColor.red.cgColor
//        hostingLConfigurationViewController.view.layer.borderWidth = 2
        
        viewManager.$isShowLConfigurationView
            .sink { [weak hostingLConfigurationViewController] isShow in
                hostingLConfigurationViewController?.view.isHidden = !isShow
            }
            .store(in: &cancellables)
        
        // 完成子视图控制器添加
        hostingLConfigurationViewController.didMove(toParent: self)
    }
    
    // MARK: Create ARFaceTrackingView

    func createLARFaceTrackingViewController() {
        let lARFaceTrackingView = LARFaceTrackingView().environmentObject(modelManager)
               
        let hostingLARFaceTrackingViewController = UIHostingController(rootView: lARFaceTrackingView)
               
        addChild(hostingLARFaceTrackingViewController)
        
        view.addSubview(hostingLARFaceTrackingViewController.view)
        
        // Auto Layout
        hostingLARFaceTrackingViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            hostingLARFaceTrackingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
//        ])
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                hostingLARFaceTrackingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5),
                hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5)
            ])
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if view.frame.width > view.frame.height{
                NSLayoutConstraint.activate([
                    hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    hostingLARFaceTrackingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -25)
                ])
            } else {
                NSLayoutConstraint.activate([
                    hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    hostingLARFaceTrackingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1)
                ])
            }
        }
        // Frame Layout
//        hostingLARFaceTrackingViewController.view.frame = CGRect(
//            x: 0,
//            y: UIScreen.main.bounds.height / 2,
//            width: 300,
//            height: UIScreen.main.bounds.height / 2 - 10
//        )
        
//        hostingLARFaceTrackingViewController.view.isHidden = true
        
        
        viewManager.$isShowLARFaceTrackingView
            .sink { [weak hostingLARFaceTrackingViewController] isShow in
                hostingLARFaceTrackingViewController?.view.isHidden = !isShow
            }
            .store(in: &cancellables)
        
        hostingLARFaceTrackingViewController.didMove(toParent: self)
    }
}
