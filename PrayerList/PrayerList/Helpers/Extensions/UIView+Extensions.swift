//
//  UIView+Extensions.swift
//  PrayerList
//
//  Created by Devin  on 22/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static func activate(constraints: [NSLayoutConstraint]) {
        constraints.forEach { ($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate(constraints)
    }
    
    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        UIView.activate(constraints: [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right)
            ])
    }
}
