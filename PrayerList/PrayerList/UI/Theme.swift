//
//  Theme.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

public class Theme {
    
    static var nightMode: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "nightmode")
        }
        get {
            return UserDefaults.standard.bool(forKey: "nightmode")
        }
    }
    
    static func createGradientLayer(color: UIColor, lighter: CGFloat = 10, view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color.lighter(by: lighter)!.cgColor, color.cgColor]
        
        return gradientLayer
    }
    
    public class Color {
        
        static var PrimaryTint: UIColor {
            return UIColor(hexString: "#59B4FB")
        }
        
        static var Background: UIColor {
            return nightMode ? UIColor(hexString: "#121212") : UIColor(hexString: "#F6F8F9")
        }
        
        static var dropShadow: UIColor {
            return nightMode ? UIColor(hexString: "#0A0A0A") : UIColor.lightGray.withAlphaComponent(0.8)
        }
        
        static var tableViewSeperator: UIColor {
            return nightMode ? UIColor.black : UIColor(hexString: "#D1D2D5")
        }
        
        static var cellColor: UIColor {
            return nightMode ? UIColor(hexString: "#242424") : UIColor.white
        }
        
        static var Subtitle: UIColor {
            return UIColor(hexString: "#C7C7C7")
        }
        
        static var Text: UIColor {
            return nightMode ? UIColor.white : UIColor(hexString: "#575757")
        }
        
        static var Grey: UIColor {
            return UIColor(hexString: "#aaaaaa")
        }
        
        static var LightGrey: UIColor {
            return UIColor(hexString: "#f0f0f0")
        }
        
        static var textFieldGrey: UIColor {
            return UIColor(hexString: "#F5F5F5")
        }
        
        static var CheckBox: UIColor {
            return nightMode ? UIColor(hexString: "#101010") : UIColor(hexString: "#E6E6E6")
        }
        
        static var Placeholder: UIColor {
            return nightMode ? UIColor(hexString: "#363636") : UIColor(hexString: "#D8D8D8")
        }
        
        static var TabBarInactive: UIColor {
            return nightMode ? UIColor(hexString: "#393939") :  UIColor(hexString: "#C6C6C6")
        }
        
        static var Error: UIColor {
            return UIColor(hexString: "#F96666")
        }
        
        static var SectionHeader: UIColor {
            return UIColor(hexString: "#BEBEBE")
        }
        
        static var Blue: UIColor {
             return UIColor(hexString: "#27386B")
            
        }
        
        static var Red: UIColor {
            return UIColor(hexString: "#E65A5A")
            
        }
        
        static var Green: UIColor {
             return UIColor(hexString: "#00CB85")
        }
        
        static var Yellow: UIColor {
             return UIColor(hexString: "#FFD7A0")
            
        }
        
        static var ButtonGrey: UIColor {
            return UIColor(hexString: "#F0F0F8")
            
        }
        
        static var LightBlue: UIColor {
            return UIColor(hexString: "#A5B3D9")
        }
    }
}
