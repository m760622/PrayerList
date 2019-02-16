//
//  CategoryOverviewCollectionViewCell.swift
//  PrayerList
//
//  Created by Devin  on 16/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class CategoryOverviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dropShadowView: UIView!
    
    static var reuseIdentifier: String = "CategoryOverviewCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 15
        
        dropShadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        dropShadowView.layer.shadowOffset = CGSize(width: 2, height: 6)
        dropShadowView.layer.shadowRadius = 10
        dropShadowView.layer.shadowOpacity = 0.2
        dropShadowView.clipsToBounds = false
        
        nameLable.textColor = Theme.Color.Text
        detailLabel.textColor = Theme.Color.Subtitle
    }
    
    func setUp(title: String, detail: String) {
        nameLable.text = title
        detailLabel.text = detail
    }

}
