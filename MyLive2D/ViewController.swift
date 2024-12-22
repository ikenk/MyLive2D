//
//  ViewController.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/22.
//

import Combine
import Metal
import QuartzCore
import SwiftUI
import UIKit

class ViewController: UIViewController {
    private var commandQueue: MTLCommandQueue?
    private var depthTexture: MTLTexture?
    
    var myViewControllerBridge: My_ViewControllerBridge = .shared()
    
    var lResourceManager: LResourceManager = .shared
    
    let modelManager: LModelManager = .init()
    
    let viewManager: LViewManager = .init()
    
    var cancellables = Set<AnyCancellable>()
    
    var lConfigurationViewConstraints: [NSLayoutConstraint] = []
    var lARFaceTrackingViewConstraints: [NSLayoutConstraint] = []
    
    var lConfigurationView: UIView = .init()
    var lARFaceTrackingView: UIView = .init()
    
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
        
//        view.layer.borderColor = UIColor.yellow.cgColor
//        view.layer.borderWidth = 2
        
        // Ensure ViewController Can be Touched
        view.isUserInteractionEnabled = true
        
        lConfigurationView = createLConfigurationViewController()
        
        lARFaceTrackingView = createLARFaceTrackingViewController()
        
        createLInfoButton()
        
        print("[MyLog]UserDefaults.standard.bool(forKey: NOT_FIRST_RUN): \(UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))")
        MyLog("UserDefaults.standard.bool(forKey: NOT_FIRST_RUN)", UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))
        
//        if !UserDefaults.standard.bool(forKey: NOT_FIRST_RUN){

        MyLog("UserDefaults.standard.bool", UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))
        guard let bundleResourcesDir = lResourceManager.getBundleResoucesDir() else { return }
            
        let _ = lResourceManager.copyBundleResourcesToLocalDirectorySync(from: bundleResourcesDir)
//        }
        
        myViewControllerBridge.viewDidLoad()
        

        MyLog("view Controller Start")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaInsets = view.safeAreaInsets

        MyLog("SafeArea Top", safeAreaInsets.top)
        MyLog("and Bottom", safeAreaInsets.bottom)
    }
    
    // iPhone ConfigView & ARFaceView Layout 
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {

        MyLog("ViewController viewWillTransition")
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NSLayoutConstraint.deactivate(lConfigurationViewConstraints)
            NSLayoutConstraint.deactivate(lARFaceTrackingViewConstraints)
            if size.width > size.height {
                // Landspace
                lConfigurationViewConstraints = [
                    lConfigurationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                    lConfigurationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    lConfigurationView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
                    lConfigurationView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: -(SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10))
                ]
                lARFaceTrackingViewConstraints = [
                    lARFaceTrackingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    lARFaceTrackingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    lARFaceTrackingView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
                    lARFaceTrackingView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: -(SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10))
                ]
            } else {
                // Portrait
                lConfigurationViewConstraints = [
                    lConfigurationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10),
                    lConfigurationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    lConfigurationView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: 0),
                    lConfigurationView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -((SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height) / 2 + 10))
                ]
                
                lARFaceTrackingViewConstraints = [
                    lARFaceTrackingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    lARFaceTrackingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    lARFaceTrackingView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: 0),
                    lARFaceTrackingView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -((SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height) / 2 + 10))
                ]
            }
            NSLayoutConstraint.activate(lConfigurationViewConstraints)
            NSLayoutConstraint.activate(lARFaceTrackingViewConstraints)
        }
    }
}

// MARK: Implement MetalViewDelegate Protocol

extension ViewController: MetalViewDelegate {
    @objc func drawableResize(_ size: CGSize) {

        MyLog("drawableResize run")
        myViewControllerBridge.drawableResize(size)
    }
    
    @objc func renderToMetalLayer(_ metalLayer: CAMetalLayer) {

        MyLog("renderToMetalLayer run")
        myViewControllerBridge.renderToMetalLayer(metalLayer)
    }
}

// MARK: - Touch Events

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location: CGPoint = touch.location(in: view)

        MyLog("Touch began at", location)
        
        // TouchesBegan Event
        myViewControllerBridge.touchesBeganAt(x: location.x, y: location.y)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)

        MyLog("Touch moved at", location)
        
        // Deal With TouchesMoved Event
        myViewControllerBridge.touchesMovedAt(x: location.x, y: location.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)

        MyLog("Touch ended at", location)
        
        // Deal With TouchesEnded Event
        myViewControllerBridge.touchesEndedAt(x: location.x, y: location.y)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("[MyLog]Touch cancelled")
        MyLog("Touch cancelled")

        // Deal With TouchesCancelled Event
    }
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
            hostingLInfoButton.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SETTING_BUTTON_OFFSET.y),
            hostingLInfoButton.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: SETTING_BUTTON_OFFSET.x),
            hostingLInfoButton.view.widthAnchor.constraint(equalToConstant: SETTING_BUTTON_SIZE.width),
            hostingLInfoButton.view.heightAnchor.constraint(equalToConstant: SETTING_BUTTON_SIZE.height)
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

    func createLConfigurationViewController() -> UIView {
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            lConfigurationViewConstraints = [
                hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5),
                hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5)
            ]
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                // Landspace
                lConfigurationViewConstraints = [
                    hostingLConfigurationViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                    hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
                    hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: -(SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10))
                ]
            } else {
                // Portrait
                lConfigurationViewConstraints = [
                    hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10),
                    hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: 0),
                    hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -((SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height) / 2 + 10))
                ]
            }
        }
        
        NSLayoutConstraint.activate(lConfigurationViewConstraints)
        
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
                if isShow {
                    hostingLConfigurationViewController?.view.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        hostingLConfigurationViewController?.view.alpha = 1.0
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        hostingLConfigurationViewController?.view.alpha = 0.0
                    } completion: { _ in
                        hostingLConfigurationViewController?.view.isHidden = true
                    }
                }
            }
            .store(in: &cancellables)
        
        // 完成子视图控制器添加
        hostingLConfigurationViewController.didMove(toParent: self)
        
        return hostingLConfigurationViewController.view
    }
    
    // MARK: Create ARFaceTrackingView

    func createLARFaceTrackingViewController() -> UIView {
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
            lARFaceTrackingViewConstraints = [
                hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                hostingLARFaceTrackingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5),
                hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5)
            ]
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                // Landspace
                lARFaceTrackingViewConstraints = [
                    hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    hostingLARFaceTrackingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: -(SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10))
                ]
            } else {
                // Portrait
                lARFaceTrackingViewConstraints = [
                    hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    hostingLARFaceTrackingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: 0),
                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -((SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height) / 2 + 10))
                ]
            }
        }
        
        NSLayoutConstraint.activate(lARFaceTrackingViewConstraints)
        
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
                if isShow {
                    hostingLARFaceTrackingViewController?.view.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        hostingLARFaceTrackingViewController?.view.alpha = 1.0
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        hostingLARFaceTrackingViewController?.view.alpha = 0.0
                    } completion: { _ in
                        hostingLARFaceTrackingViewController?.view.isHidden = true
                    }
                }
            }
            .store(in: &cancellables)
        
        hostingLARFaceTrackingViewController.didMove(toParent: self)
        
        return hostingLARFaceTrackingViewController.view
    }
}
