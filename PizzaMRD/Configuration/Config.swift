//
//  Config.swift
//  PizzaMRD
//
//  Created by Ramana on 10/03/2018.
//  Copyright © 2018 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

enum LabelViewType: String {
  case mrd = "mrd"
  case bb  = "bb"
}

class Config {
    static let shared = Config()
    private var colorPalette: [String:String] {
        return Bundle.main.object(forInfoDictionaryKey: "ColorPalette") as! [String:String]
    }
  
  private var labelView: [String:String] {
    return Bundle.main.object(forInfoDictionaryKey: "Config") as! [String:String]
  }
    private func color(with hexString: String?) -> UIColor {
        guard let hex = hexString else {
            return .black
        }
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var primaryColor: UIColor {
        return color(with: colorPalette["primary"])
    }
    
    var secondaryColor: UIColor {
        return color(with: colorPalette["secondary"])
    }
    
    var tertiaryColor: UIColor {
        return color(with: colorPalette["tertiary"])
    }
    
    var textColor: UIColor {
        return color(with: colorPalette["text"])
    }
    
    var staticTextColor: UIColor {
        return color(with: colorPalette["staticText"])
    }
    
    var viewBackgroundColor: UIColor  {
        return color(with: colorPalette["viewBackground"])
    }
    
    var cellBackgroundColor: UIColor {
        return color(with: colorPalette["cellBackground"])
    }
  
  func getLabelViewType() -> LabelViewType {
    if let value = labelView["LabelView"], let lblView = LabelViewType(rawValue: value) {
      return lblView
    } else {
      return .mrd
    }
  }
}
