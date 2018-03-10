//
//  MRDPrintView.swift
//  PizzaMRD
//
//  Created by Ramana Reddy on 28/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

let mrdWidthValue = 95
let mrdHeightValue = 87

class MRDPrintView:UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var madeLabel: UILabel!
    @IBOutlet weak var madeDateLabel: UILabel!
    @IBOutlet weak var madeTimeLabel: UILabel!
    
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var readyDateLabel: UILabel!
    @IBOutlet weak var readyTimeLabel: UILabel!
    
    @IBOutlet weak var discardLabel: UILabel!
    @IBOutlet weak var discardDateLabel: UILabel!
    @IBOutlet weak var discardTimeLabel: UILabel!
    
    init(printInfo: [String:String]){
        super.init(frame: CGRect(x: 0,y: 0,width: mrdWidthValue,height: mrdHeightValue))
        nibSetup()
        titleLabel.text = printInfo[titleString]
        madeDateLabel.text = printInfo[madeDateString]
        madeTimeLabel.text = printInfo[madeTimeString]
        readyDateLabel.text = printInfo[readyDateString]
        readyTimeLabel.text = printInfo[readyTimeString]
        discardDateLabel.text = printInfo[discardDateString]
        discardTimeLabel.text = printInfo[discardTimeString]
    }
    
    override init(frame: CGRect)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    fileprivate func nibSetup()
    {
        backgroundColor = UIColor.clear
        view = loadViewFromNib()
        let frame = CGRect(x: 0,y: 0,width: mrdWidthValue,height: mrdHeightValue)
        view.frame = frame
        bounds = view.frame
        
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 2.0
        addSubview(view)
        
        applyBorderChanges(to: titleLabel)
        applyBorderChanges(to: madeLabel)
        applyBorderChanges(to: madeDateLabel)
        applyBorderChanges(to: madeTimeLabel)
        applyBorderChanges(to: readyLabel)
        applyBorderChanges(to: readyDateLabel)
        applyBorderChanges(to: readyTimeLabel)
        applyBorderChanges(to: discardLabel)
        applyBorderChanges(to: discardDateLabel)
        applyBorderChanges(to: discardTimeLabel)
    }
    
    fileprivate func loadViewFromNib() -> UIView
    {
        let nib = UINib(nibName: String(describing: MRDPrintView.self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func applyBorderChanges(to label:UILabel) {
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        
    }
}

//extension CALayer {
//    
//    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
//        
//        let border = CALayer()
//        
//        switch edge {
//        case UIRectEdge.top:
//            border.frame = CGRect(x:0, y:0, width: self.frame.width, height: thickness)
//            break
//        case UIRectEdge.bottom:
//            border.frame = CGRect(x:0, y:self.frame.height - thickness, width: self.frame.width, height: thickness)
//            break
//        case UIRectEdge.left:
//            border.frame = CGRect(x:0, y:0, width:thickness, height: self.frame.height)
//            break
//        case UIRectEdge.right:
//            border.frame = CGRect(x: self.frame.width - thickness, y:0, width: thickness, height: self.frame.height)
//            break
//        default:
//            break
//        }
//
//        border.backgroundColor = color.cgColor
//        
//        self.addSublayer(border)
//    }
//}
