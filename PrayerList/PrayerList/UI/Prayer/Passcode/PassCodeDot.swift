//
//  PassCodeDot.swift
//  PrayerList
//
//  Created by Devin  on 7/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class PassCodeDot: UIView, NibInstantiatable {

    @IBOutlet weak var dot: UIView!
    
    var isActive: Bool = false
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.height / 2
        
        self.backgroundColor = Theme.Color.PrimaryTint.withAlphaComponent(0.3)
    }
    
    func setActive(){
        self.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = Theme.Color.PrimaryTint.withAlphaComponent(1)
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
        }) { (completed) in
            
        }
    }
    
    func setInactive(){
        self.isActive = false
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = Theme.Color.PrimaryTint.withAlphaComponent(0.3)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (completed) in
            
        }
    }

}
