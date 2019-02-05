//
//  EmptyView.swift
//  PrayerList
//
//  Created by Devin  on 20/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

protocol EmptyViewButtonActionDelegate: class {
    func emptyViewAction()
}

class EmptyView: UIView, NibInstantiatable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: EmptyViewButtonActionDelegate?
    
    func setUp(title: String, subtitle: String, image: UIImage?, parentView: UIView, buttonTitle: String? = nil, buttonColor: UIColor? = nil){
        self.subtitleLabel.text = subtitle
        self.titleLabel.text = title
        
        if let image = image {
            self.imageView.image = image
            self.imageView.isHidden = false
        } else {
            self.imageView.isHidden = true
        }
        
        if let buttonTitle = buttonTitle {
            button.isHidden = false
            button.setTitle(buttonTitle, for: .normal)
            button.backgroundColor = buttonColor
        } else {
            button.isHidden = true
        }
        
        imageView.tintColor = UIColor.black.withAlphaComponent(0.05)
        
        titleLabel.textColor = Theme.Color.Text
        subtitleLabel.textColor = Theme.Color.Subtitle
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        parentView.addConstraints([horizontalConstraint, verticalConstraint])
        
        styleButton()
    }
    
    func styleButton(){
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.titleLabel?.textColor = .white
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.emptyViewAction()
    }
}
