//
//  MRDPrintView.swift
//  PizzaMRD
//
//  Created by Ramana Reddy on 28/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

protocol PrintViewDelegate: class {
    func didOK()
}

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
    
    @IBOutlet weak var okButton: UIButton!
    weak var delegate: PrintViewDelegate?
    
    init(printInfo: [String]){
        super.init(frame: CGRect(x: 0,y: 0,width: 160,height: 228))
        nibSetup()
        titleLabel.text = printInfo[0]
//        madeDateLabel.text = printInfo[1]
//        madeTimeLabel.text = printInfo[2]
//        readyDateLabel.text = printInfo[3]
//        readyTimeLabel.text = printInfo[4]
        discardDateLabel.text = printInfo[5]
//        discardTimeLabel.text = printInfo[6]
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
//        let frame = CGRect(x: 0,y: 0,width: 160,height: 228)
        let frame = CGRect(x: 0,y: 0,width: 160,height: 64)
        view.frame = frame
        bounds = view.frame
        
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 2.0
        addSubview(view)
        
        applyBorderChanges(to: titleLabel)
//        applyBorderChanges(to: madeLabel)
//        applyBorderChanges(to: madeDateLabel)
//        applyBorderChanges(to: madeTimeLabel)
//        applyBorderChanges(to: readyLabel)
//        applyBorderChanges(to: readyDateLabel)
//        applyBorderChanges(to: readyTimeLabel)
//        applyBorderChanges(to: discardLabel)
        applyBorderChanges(to: discardDateLabel)
//        applyBorderChanges(to: discardTimeLabel)
    }
    
    fileprivate func loadViewFromNib() -> UIView
    {
        let nib = UINib(nibName: String(describing: BestBeforePrintView.self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func applyBorderChanges(to label:UILabel) {
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        delegate?.didOK()
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
