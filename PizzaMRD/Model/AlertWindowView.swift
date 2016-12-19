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
	
	@discardableResult func show(_ title: String, _ message: String) {
		if newALertWindow != nil {
			return
		}
		let rootViewController = createWindowOverlay()
		let alertBackground = createAlertView(title, message)
		alertBackground.layer.cornerRadius = 6.0
		alertBackground.layer.masksToBounds = true
		
		rootViewController.view.addSubview(alertBackground)
		
		var layoutMetrics = ["WIDTH": 240, "WIDTH_PRIORITY": 750]
		if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
			layoutMetrics["EDGEINSET"] = 40
		} else {
			layoutMetrics["EDGEINSET"] = 20
		}
		
		rootViewController.view.addConstraint(NSLayoutConstraint(item: alertBackground, attribute: .centerX, relatedBy: .equal, toItem: rootViewController.view, attribute: .centerX, multiplier: 1, constant: 0))
		rootViewController.view.addConstraint(NSLayoutConstraint(item: alertBackground, attribute: .centerY, relatedBy: .equal, toItem: rootViewController.view, attribute: .centerY, multiplier: 1, constant: 0))
		rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=EDGEINSET)-[backGround(==WIDTH@WIDTH_PRIORITY)]-(>=EDGEINSET)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: ["backGround":alertBackground]))
		rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=EDGEINSET)-[backGround]-(>=EDGEINSET)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: ["backGround":alertBackground]))
		
		alertBackground.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
		alertBackground.alpha = 0.3
		UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
			alertBackground.transform = CGAffineTransform.identity
			alertBackground.alpha = 1.0
		}, completion: nil)
		
		dismissAnimations = {
			UIView.animate(withDuration: 0.3, animations: {
				alertBackground.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
				alertBackground.alpha = 0.3
			})
		}
	}
	
	func createAlertView(_ title: String, _ message: String) -> UIVisualEffectView{
		let alertBackgroud = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		alertBackgroud.translatesAutoresizingMaskIntoConstraints = false
		
		var layoutViews = [String: UIView]()
		var layoutMetrics = [String: Int]()
		
		layoutMetrics["WIDTH"] = 240
		layoutMetrics["WIDTH_PRIORITY"] = 750
		layoutViews["background"] = alertBackgroud
		
		//Title
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.text = title
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.font = UIFont.systemFont(ofSize: 16.0)
		titleLabel.minimumScaleFactor = 0.5
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor.white
		alertBackgroud.addSubview(titleLabel)
		layoutViews["title"] = titleLabel
		
		alertBackgroud.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: layoutViews))
		alertBackgroud.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title(==WIDTH@WIDTH_PRIORITY)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: layoutViews))
		
		//Message
		let messageLabel = UILabel()
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.textColor = UIColor.white
		messageLabel.font = UIFont.systemFont(ofSize: 15.0)
		messageLabel.adjustsFontSizeToFitWidth = true
		messageLabel.minimumScaleFactor = 0.8
		messageLabel.textAlignment = .center
		messageLabel.numberOfLines = 0
		messageLabel.lineBreakMode = .byTruncatingTail
		messageLabel.text = message
		
		alertBackgroud.addSubview(messageLabel)
		layoutViews["message"] = messageLabel
		alertBackgroud.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[message(==WIDTH@WIDTH_PRIORITY)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: layoutViews))
		
		let separatorLine = UIImageView(image: UIImage(named:"separator_line"))
		separatorLine.translatesAutoresizingMaskIntoConstraints = false
		alertBackgroud.addSubview(separatorLine)
		layoutViews["line"] = separatorLine
		
		alertBackgroud.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: layoutViews))
		separatorLine.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(2)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: layoutViews))
		alertBackgroud.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-(12)-[message]-[line]", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: layoutViews))
		
		//Button
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
		button.titleLabel?.minimumScaleFactor = 0.2
		button.titleLabel?.adjustsFontSizeToFitWidth = true
		button.setTitle("OK", for: .normal)
		button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
		button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)
		button.setContentCompressionResistancePriority(800, for: .horizontal)
		alertBackgroud.addSubview(button)
		layoutViews["button"] = button
		
		alertBackgroud.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: layoutViews))
		alertBackgroud.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line]-(10)-[button(==50)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layoutMetrics, views: layoutViews))
		
		applyMotionEffects(alertBackgroud)
		
		return alertBackgroud
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

