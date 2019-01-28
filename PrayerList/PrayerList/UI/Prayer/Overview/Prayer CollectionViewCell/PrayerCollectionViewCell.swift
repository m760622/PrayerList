//
//  PrayerCollectionViewCell.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class PrayerCollectionViewCell: UICollectionViewCell {
    
    static var resuseIdentifier: String = "PrayerCollectionViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var dropshadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        dropshadowView.layer.shadowOffset = CGSize(width: 2, height: 6)
        dropshadowView.layer.shadowRadius = 10
        dropshadowView.layer.shadowOpacity = 0.3
        dropshadowView.clipsToBounds = false
        self.clipsToBounds = false
        
        containerView.clipsToBounds = true
    }
    
    func setUp(title: String, backgroundColor: UIColor, textColor: UIColor){
        titleLabel.text = title
        titleLabel.textColor = textColor
        dropshadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        
        containerView.bottomColor = backgroundColor
        containerView.topColor = backgroundColor
    }
    
    func setUp(title: String, bottomColor: UIColor, topColor: UIColor, textColor: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = textColor
        dropshadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        
        containerView.bottomColor = bottomColor
        containerView.topColor = topColor
    }

}
