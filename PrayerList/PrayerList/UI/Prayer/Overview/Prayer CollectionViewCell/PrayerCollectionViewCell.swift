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
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var dropshadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        dropshadowView.layer.shadowOffset = CGSize(width: 2, height: 6)
        dropshadowView.layer.shadowRadius = 10
        dropshadowView.layer.shadowOpacity = 0.2
        dropshadowView.clipsToBounds = false
        self.clipsToBounds = false
        
        containerView.clipsToBounds = true
        
        subtitleLabel.alpha = 0.7
    }
    
    func setUp(title: String, subtitle: String? = nil, backgroundColor: UIColor, textColor: UIColor, fontSize: Int = 26, cornerRadius: Int = 20){
        titleLabel.text = title
        titleLabel.textColor = textColor
        dropshadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
        
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .medium)
        containerView.cornerRadius = CGFloat(cornerRadius)
        
        containerView.bottomColor = backgroundColor
        containerView.topColor = backgroundColor
    }
    
    func setUp(title: String, subtitle: String? = nil, bottomColor: UIColor, topColor: UIColor, textColor: UIColor, fontSize: Int = 26, cornerRadius: Int = 20) {
        titleLabel.text = title
        titleLabel.textColor = textColor
        dropshadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
        
        containerView.cornerRadius = CGFloat(cornerRadius)
        
        containerView.bottomColor = bottomColor
        containerView.topColor = topColor
        
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .medium)
    }

}
