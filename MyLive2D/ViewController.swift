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
        
//        lARFaceTrackingView = createLARFaceTrackingViewController()
        
        createLInfoButton()
        
        print("[MyLog]UserDefaults.standard.bool(forKey: NOT_FIRST_RUN): \(UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))")
        MyLog("UserDefaults.standard.bool(forKey: NOT_FIRST_RUN)", UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))
        
//        if !UserDefaults.standard.bool(forKey: NOT_FIRST_RUN){
//        print("[MyLog]UserDefaults.standard.bool run")
        MyLog("UserDefaults.standard.bool", UserDefaults.standard.bool(forKey: NOT_FIRST_RUN))
        guard let bundleResourcesDir = lResourceManager.getBundleResoucesDir() else { return }
            
        let _ = lResourceManager.copyBundleResourcesToLocalDirectorySync(from: bundleResourcesDir)
//        }
        
        myViewControllerBridge.viewDidLoad()
        
//        print("[MyLog]view Controller Start")
        MyLog("view Controller Start")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaInsets = view.safeAreaInsets
//        print("[MyLog]SafeArea Top: \(safeAreaInsets.top) and Bottom: \(safeAreaInsets.bottom)")
        MyLog("SafeArea Top", safeAreaInsets.top)
        MyLog("and Bottom", safeAreaInsets.bottom)
    }
    
    // iPhone ConfigView & ARFaceView Layout
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
//        print("[MyLog]ViewController viewWillTransition")
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
//        print("[MyLog]drawableResize run")
        MyLog("drawableResize run")
        myViewControllerBridge.drawableResize(size)
    }
    
    @objc func renderToMetalLayer(_ metalLayer: CAMetalLayer) {
//        print("[MyLog]renderToMetalLayer run")
//        MyLog("renderToMetalLayer run")
        myViewControllerBridge.renderToMetalLayer(metalLayer)
    }
}

// MARK: - Touch Events

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location: CGPoint = touch.location(in: view)
//        print("[MyLog]Touch began at: \(location)")
        MyLog("Touch began at", location)
        
        // TouchesBegan Event
        myViewControllerBridge.touchesBeganAt(x: location.x, y: location.y)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
//        print("[MyLog]Touch moved to: \(location)")
        MyLog("Touch moved at", location)
        
        // Deal With TouchesMoved Event
        myViewControllerBridge.touchesMovedAt(x: location.x, y: location.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
//        print("[MyLog]Touch ended at: \(location)")
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
