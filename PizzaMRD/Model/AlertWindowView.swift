//
//  AlertWindowView.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 01/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

//MARK:- AlertWindowViewDelegate

protocol AlertWindowViewDelegate : class
{
    func didDismissWithButtonIndex(_ index: Int, forIdentifier: Any?)
}

@objc protocol AlertWindowViewDelegate_objc : class
{
    func didDismissWithButtonIndex(_ index: Int, andIdentifier: Int)
}

//MARK:- AlertWindowView

class AlertWindowView : NSObject
{
    // Singleton Initialiser in Swift
    
    static let sharedInstance = AlertWindowView()
    override fileprivate init() {}                               // Prevent using the default '()' initializer for this class.
    
    enum ButtonType
    {
        case standard, gray, transactions
    }
    
    struct k {
        static let dismissTime = 0.3
    }
    
    weak var delegate : AlertWindowViewDelegate?
    weak var objcDelegate : AlertWindowViewDelegate_objc?
    var identifier : Any?
    var objcIdentifier : Int = 0
    
    var newALertWindow : UIWindow?
    var dismissAnimations : (()->Void)?
    
    var oldWindow : UIWindow?
    
    //MARK:- Functions
    
    func createWindowOverlay() -> WindowRootViewController
    {
        // Root View controller for Alert Window
        
        let windowRootViewController = WindowRootViewController()
        
        // Alert Window
        
        oldWindow = UIApplication.shared.keyWindow
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert + 1
        window.rootViewController = windowRootViewController
        window.makeKeyAndVisible()
        self.newALertWindow = window
        
        // Animate background darkness
        
        animateWindowFadeInOnView(windowRootViewController.view)
        
        return windowRootViewController
    }
    
    @discardableResult func showWithView(_ view: UIView, animations:(() -> Void)? = nil, dismissAnimations: (() -> Void)? = nil) -> Bool
    {
        if newALertWindow != nil {
            return false
        }
        
        self.dismissAnimations = dismissAnimations
        
        let rootViewController = self.createWindowOverlay()
        rootViewController.view.addSubview(view)
        
        if let animations = animations {
            animations()
        } else {
            view.center = rootViewController.view.center
        }
        return true
    }
    
    func buttonPressed(_ button: UIButton)
    {
        dismissAlert()
        let delegateCopy        = self.delegate
        let objcDelegateCopy    = self.objcDelegate
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(k.dismissTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            delegateCopy?.didDismissWithButtonIndex(button.tag, forIdentifier: self.identifier)
            objcDelegateCopy?.didDismissWithButtonIndex(button.tag, andIdentifier: self.objcIdentifier)
        }
        
    }
    
    func dismissAlert()
    {
        func closeDown()
        {
            self.newALertWindow?.rootViewController = nil
            self.newALertWindow = nil
            self.dismissAnimations = nil
            self.delegate = nil
            self.objcDelegate = nil
            oldWindow?.makeKeyAndVisible()
        }
        
        if let animations = self.dismissAnimations
        {
            if let view = self.newALertWindow?.rootViewController?.view
            {
                animateWindowFadeOutOnView(view)
            }
            
            animations()
            
            // Max 0.3 seconds for fade out animations, then destroy window and resturn to normal window
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(k.dismissTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                closeDown()
            }
        }
        else
        {
            closeDown()
        }
    }
    
    func isShowingAlert() -> Bool {
        return  self.newALertWindow != nil
    }
    
    func animateWindowFadeInOnView(_ view: UIView)
    {
        // Animate Background Color Change (seperate from UIView animations passed in block)
        let bgColor = CABasicAnimation(keyPath: "backgroundColor")
        bgColor.fromValue = UIColor.clear.cgColor
        bgColor.toValue   = UIColor.black.withAlphaComponent(0.5).cgColor
        bgColor.duration = 0.6
        bgColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.add(bgColor, forKey: "bgColorStartAnimation")
    }
    
    func animateWindowFadeOutOnView(_ view: UIView)
    {
        // Animate Background Color Change (seperate from UIView animations passed in block)
        let bgColor = CABasicAnimation(keyPath: "backgroundColor")
        bgColor.fromValue = UIColor.black.withAlphaComponent(0.5).cgColor
        bgColor.toValue   = UIColor.clear.cgColor
        bgColor.duration = 0.3
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.add(bgColor, forKey: "bgColorEndAnimation")
    }
    
    func applyMotionEffects(_ view: UIVisualEffectView)
    {
        func motionEffectWithKeyPath(_ keyPath: String, type:UIInterpolatingMotionEffectType) -> UIInterpolatingMotionEffect
        {
            let effect = UIInterpolatingMotionEffect(keyPath:keyPath, type:type)
            effect.minimumRelativeValue = -20
            effect.maximumRelativeValue = 20
            return effect
        }
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [motionEffectWithKeyPath("center.x", type: .tiltAlongHorizontalAxis),
                                           motionEffectWithKeyPath("center.y", type: .tiltAlongVerticalAxis)]
        view.addMotionEffect(motionEffectGroup)
    }
}

//MARK:- Root View COntroller for WIndow

class WindowRootViewController: UIViewController
{
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    override var prefersStatusBarHidden : Bool {
        return UIApplication.shared.isStatusBarHidden
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    deinit {
        print("WindowRootViewController -DEINIT")
    }
}

