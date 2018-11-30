//
//  Button.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {
    var loadingIndicator: UIActivityIndicatorView?
    var buttonText: String!
    
    @IBInspectable var dropshadow: Bool = false
    @IBInspectable var shadowRadius: CGFloat = 10
    
    private var animator = UIViewPropertyAnimator()
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.backgroundColor = Theme.Color.PrimaryTint
        self.titleLabel?.textColor = UIColor.white
        self.buttonText = self.titleLabel?.text
        
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchDown), for: .touchDragEnter)
        
        self.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp), for: .touchDragExit)
        self.addTarget(self, action: #selector(touchUp), for: .touchCancel)
        
        if dropshadow {
            layer.shadowColor = Theme.Color.PrimaryTint.cgColor
            layer.shadowOffset = CGSize(width: 2, height: 8.0)
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = 0.4
        }
    }
    
    func showActivityIndicator(){
        self.setTitle("", for: .normal)
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40));
        loadingIndicator?.color = .white
        loadingIndicator?.center = self.center
        loadingIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview((loadingIndicator)!)
        self.bringSubviewToFront(loadingIndicator!)
        centerActivityIndicatorInButton()
        loadingIndicator?.startAnimating()
    }
    
    func hideActivityIndicator(){
        self.setTitle(buttonText, for: .normal)
        loadingIndicator?.removeFromSuperview();
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: loadingIndicator!, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: loadingIndicator!, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
    @objc private func touchDown() {
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
        animator.startAnimation()
    }
    
    @objc private func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.12, curve: .easeOut, animations: {
            self.transform = CGAffineTransform.identity
        })
        animator.startAnimation()
    }
}
