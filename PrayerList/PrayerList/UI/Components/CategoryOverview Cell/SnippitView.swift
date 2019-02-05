//
//  SnippitView.swift
//  PrayerList
//
//  Created by Devin  on 5/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

class SnippitView: UIView, NibInstantiatable {
    
    @IBOutlet weak var label: UILabel!
    
    func setUp(text: String, textColor: UIColor, backgroundColor: UIColor) {
        label.text = text
        label.textColor = textColor
        self.backgroundColor = backgroundColor
        
        
    }
    
    func layout(){
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.height / 2
    }
}


