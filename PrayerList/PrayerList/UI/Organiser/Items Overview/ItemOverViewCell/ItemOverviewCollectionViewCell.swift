//
//  GroupOverviewCollectionViewCell.swift
//  PrayerList
//
//  Created by Devin  on 1/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class ItemOverviewCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "ItemOverviewCollectionViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
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
        containerView.layer.cornerRadius = 20
    }
    
    func setUp(title: String, detail: String, backgroundColor: UIColor, textColor: UIColor, detailTextColor: UIColor){
        titleLabel.text = title
        titleLabel.textColor = textColor
        detailLabel.text = detail
        detailLabel.textColor = detailTextColor
        dropshadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        
        containerView.backgroundColor = backgroundColor
    }

}
