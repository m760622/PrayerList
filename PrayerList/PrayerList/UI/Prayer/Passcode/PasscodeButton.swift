//
//  PasscodeButton.swift
//  PrayerList
//
//  Created by Devin  on 7/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

class PasscodeButton: UIButton {
    
    @IBInspectable var number: Int = 0
    
    private var animator = UIViewPropertyAnimator()
    
    override func awakeFromNib() {
        self.setTitle("\(number)", for: .normal)
        
        self.setTitleColor(Theme.Color.PrimaryTint, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.setTitleColor(.white, for: .highlighted)
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.height / 2
        
        self.backgroundColor = .white
        
        self.layer.shadowColor = Theme.Color.dropShadow.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 6)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchDown), for: .touchDragEnter)
        
        addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        addTarget(self, action: #selector(touchUp), for: .touchDragExit)
        addTarget(self, action: #selector(touchUp), for: .touchCancel)
    }
    
    @objc private func touchDown() {
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.backgroundColor = Theme.Color.PrimaryTint
        })
        animator.startAnimation()
    }
    
    @objc private func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.12, curve: .easeOut, animations: {
            self.transform = CGAffineTransform.identity
            self.backgroundColor = .white
        })
        animator.startAnimation()
    }
}
