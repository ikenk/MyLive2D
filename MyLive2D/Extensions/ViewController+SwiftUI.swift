//
//  ViewController+SwiftUI.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/05/04.
//

import SwiftUI

///  Create SwiftUI Views
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
//            lConfigurationViewConstraints = [
//                hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//                hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5),
//                hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -5)
//            ]
            lConfigurationViewConstraints = [
                hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2 * SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height),
                hostingLConfigurationViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 3)
            ]
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                // Landspace
//                lConfigurationViewConstraints = [
//                    hostingLConfigurationViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//                    hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                    hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
//                    hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: -(SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10))
//                ]
                lConfigurationViewConstraints = [
                    hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 5),
                    hostingLConfigurationViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
                ]
            } else {
                // Portrait
//                lConfigurationViewConstraints = [
//                    hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10),
//                    hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                    hostingLConfigurationViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: 0),
//                    hostingLConfigurationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -((SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height) / 2 + 10))
//                ]
                lConfigurationViewConstraints = [
                    hostingLConfigurationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 5),
                    hostingLConfigurationViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
//                    hostingLConfigurationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                    hostingLConfigurationViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
        hostingLConfigurationViewController.view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0)
//        hostingLConfigurationViewController.view.layer.borderColor = UIColor.red.cgColor
//        hostingLConfigurationViewController.view.layer.borderWidth = 2
        
        // 处理显示/隐藏动画
        viewManager.$isShowLConfigurationView
            .sink { [weak hostingLConfigurationViewController] isShow in
                guard let hostingView = hostingLConfigurationViewController?.view else { return }
                   
                // 确保在动画开始前更新布局
                hostingView.layoutIfNeeded()
                   
                if isShow {
                    hostingView.isHidden = false
                       
                    // 初始化变换
                    var transform = CGAffineTransform.identity
                       
                    // 应用缩放
                    if hostingView.bounds.width > UIScreen.main.bounds.width {
                        let scale = UIScreen.main.bounds.width / hostingView.bounds.width
                        transform = transform.scaledBy(x: scale, y: scale)
                    }
                       
                    // 设置初始位置（屏幕右侧）
                    transform = transform.translatedBy(x: hostingView.bounds.width, y: 0)
                    hostingView.transform = transform
                    
                    MyLog("hostingView.bounds.size.width", hostingView.bounds.size.width)
                    MyLog("hostingView.transform.tx", hostingView.transform.tx)
                       
                    // 执行动画
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
//                        self.view.alpha = 1.0
                        // 只移除平移，保持缩放
                        if hostingView.bounds.width > UIScreen.main.bounds.width {
                            let scale = UIScreen.main.bounds.width / hostingView.bounds.width
                            hostingView.transform = CGAffineTransform(scaleX: scale, y: scale)
                        } else {
                            hostingView.transform = .identity
                        }
                    }
                } else {
                    // 获取当前变换状态
                    let currentTransform = hostingView.transform
                       
                    // 执行滑出动画
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
//                        self.view.alpha = 0
                        // 在当前变换基础上添加平移
                        let translateTransform = CGAffineTransform(translationX: hostingView.bounds.width, y: 0)
                        hostingView.transform = currentTransform.concatenating(translateTransform)
                    } completion: { _ in
                        hostingView.isHidden = true
                        // 重置为原始缩放状态
                        if hostingView.bounds.width > UIScreen.main.bounds.width {
                            let scale = UIScreen.main.bounds.width / hostingView.bounds.width
                            hostingView.transform = CGAffineTransform(scaleX: scale, y: scale)
                        } else {
                            hostingView.transform = .identity
                        }
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
                hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -5),
                hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -5)
            ]
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                // Landspace
                lARFaceTrackingViewConstraints = [
                    hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    hostingLARFaceTrackingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -5),
//                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: -(SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10))
                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3, constant: -5),
                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3, constant: -(SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height + 10))
                ]
            } else {
                // Portrait
                lARFaceTrackingViewConstraints = [
                    hostingLARFaceTrackingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    hostingLARFaceTrackingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: 0),
//                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -((SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height) / 2 + 10))
                    hostingLARFaceTrackingViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3, constant: 0),
                    hostingLARFaceTrackingViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3, constant: -((SETTING_BUTTON_OFFSET.y + SETTING_BUTTON_SIZE.height) / 2 + 10))
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
