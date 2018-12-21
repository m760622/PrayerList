//
//  PlusView.swift
//  PrayerList
//
//  Created by Devin  on 15/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol PlusDelegate: class {
    func action()
}

class PlusView: UIView, NibInstantiatable {

    @IBOutlet weak var button: UIButton!
    
    weak var delegate: PlusDelegate?
    
    private var animator = UIViewPropertyAnimator()
    
    override func awakeFromNib() {
        
        
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchDown), for: .touchDragEnter)
        
        button.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUp), for: .touchDragExit)
        button.addTarget(self, action: #selector(touchUp), for: .touchCancel)
        
        self.button.backgroundColor = Theme.Color.PrimaryTint
        button.tintColor = UIColor.white
        
        
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.15
    }
    
    func setUp(){
        self.fillSuperview()
        self.button.layoutIfNeeded()
        self.button.layer.cornerRadius = self.button.bounds.width / 2
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.action()
    }
    
    @objc private func touchDown() {
        //animator.stopAnimation(true)
        
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
