//
//  TabBarController.swift
//  PrayerList
//
//  Created by Devin  on 15/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol TabPlusDelegate: class {
    func hide()
    func show()
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var plus: PlusView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.delegate = self
        let containerView = UIView()
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        plus = PlusView.instantiate()
        containerView.addSubview(plus)
        plus.setUp()
        
        // anchor your view right above the tabBar
        containerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 35).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}

extension TabBarController: TabPlusDelegate {
    func hide() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.plus.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.plus.alpha = 0
        }) { (_) in
            self.plus.isHidden = true
        }
    }
    
    func show() {
        self.plus.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.plus.transform = .identity
            self.plus.alpha = 1
        }) { (_) in
            
        }
    }
    
    
}

