//
//  BestBeforePrintView.swift
//  PizzaMRD
//
//  Created by Ramana on 27/02/2018.
//  Copyright © 2018 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

let widthValue = 115
let heightValue = 32

class BestBeforePrintView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discardLabel: UILabel!
    @IBOutlet weak var bestBeforeLabel: UILabel!
    
    init(printInfo: [String:String]){
        super.init(frame: CGRect(x: 0,y: 0,width: widthValue,height: heightValue))
        
        nibSetup()
        titleLabel.text = printInfo[titleString]
        discardLabel.text = printInfo[discardDateString]
    }
    
    private func nibSetup() {
        view = loadViewFromNib()
        let frame = CGRect(x: 0,y: 0,width: widthValue,height: heightValue)
        view.frame = frame
        bounds = view.frame
        addSubview(view)
      
        applyBorderChanges(to: titleLabel)
        applyBorderChanges(to: discardLabel)
        applyBorderChanges(to: bestBeforeLabel)
//        rotateLabel()
    }
    
    override init(frame: CGRect)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    fileprivate func loadViewFromNib() -> UIView
    {
        let nib = UINib(nibName: String(describing: BestBeforePrintView.self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    private func applyBorderChanges(to label:UILabel) {
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        
    }
    
    private func rotateLabel() {
        bestBeforeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
}
