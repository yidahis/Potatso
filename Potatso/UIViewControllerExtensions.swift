//
//  UIViewControllerExtensions.swift
//  Potatso
//
//  Created by LEI on 12/12/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import UIKit
import Aspects

class GodfatherSwizzing: NSObject {
    
    static let sourceJoinedCharacter: String = "-"
    
    func aopFunction() {}
}

class VCSwizzing: GodfatherSwizzing {
    /// vc-viewdidappear
    let viewdidAppearBlock: @convention(block) (_ id : AspectInfo)->Void = { aspectInfo in
//        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: true)
//        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction:event])
    }
    
    /// vc-viewdiddisappear
    let viewdidDisappearBlock:@convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
//        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: false)
//        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction:event])
    }
    
    /// vc-viewdidappear & diddisappear
    override func aopFunction() {
        do {
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidAppear(_:)),
                                             with: .init(rawValue: 0),
                                             usingBlock: self.viewdidAppearBlock)
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidDisappear(_:)),
                                             with: .init(rawValue:0),
                                             usingBlock: viewdidDisappearBlock)
        }catch {}
    }
}


extension UIViewController: UIGestureRecognizerDelegate  {
    
    
    class func hook() {
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        let viewDidLoadBlock: @convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
            
            }
        let viewWillAppearBlock: @convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
            if let vc = aspectInfo.instance() as? UIViewController, let navVC = vc.navigationController {
                if !vc.isModal() {
                    vc.showLeftBackButton(navVC.viewControllers.count > 1)
                }
            }
        }
        let viewDidAppearBlock: @convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
            if let vc = aspectInfo.instance() as? UIViewController, let navVC = vc.navigationController {
                navVC.enableSwipeGesture(navVC.viewControllers.count > 1)
            }
        }
        let viewWillDisappearBlock: @convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
            
        }
        
        
        
        do {
            try UIViewController.aspect_hook(#selector(viewDidLoad), with: AspectOptions.positionInstead, usingBlock: viewDidLoadBlock)
            try UIViewController.aspect_hook(#selector(viewWillAppear), with: AspectOptions.positionInstead, usingBlock: viewWillAppearBlock)
            try UIViewController.aspect_hook(#selector(viewDidAppear), with: AspectOptions.positionInstead, usingBlock: viewDidAppearBlock)
            try UIViewController.aspect_hook(#selector(viewWillDisappear), with: AspectOptions.positionInstead, usingBlock: viewWillDisappearBlock)
            
        }catch {}
    }
    
    // MARK: - Method Swizzling
    
    func ics_viewWillAppear(_ animated: Bool) {
        self.ics_viewWillAppear(animated)
        if let navVC = self.navigationController {
            if !isModal() {
                showLeftBackButton(navVC.viewControllers.count > 1)
            }
        }
    }
    
    func ics_viewDidLoad() {
        self.ics_viewDidLoad()
    }
    
    func ics_viewDidAppear(_ animated: Bool) {
        self.ics_viewDidAppear(animated)
        if let navVC = self.navigationController {
            enableSwipeGesture(navVC.viewControllers.count > 1)
        }
    }
    
    func ics_viewWillDisappear(_ animated: Bool) {
        self.ics_viewWillDisappear(animated)
    }
    
    func showLeftBackButton(_ shouldShow: Bool) {
        if shouldShow {
            let backItem = UIBarButtonItem(image: "Back".templateImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(pop))
            navigationItem.leftBarButtonItem = backItem
        }else{
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func enableSwipeGesture(_ shouldShow: Bool) {
        if shouldShow {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }else{
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    func addChildVC(_ child: UIViewController) {
        view.addSubview(child.view)
        addChildViewController(child)
        child.didMove(toParentViewController: self)
    }

    func removeChildVC(_ child: UIViewController) {
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        child.removeFromParentViewController()
    }
    
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func close() {
        if let navVC = self.navigationController, navVC.viewControllers.count > 1 {
            pop()
        }else {
            dismiss()
        }
    }

    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        }
        if self.presentingViewController?.presentedViewController == self {
            return true
        }
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }

}
