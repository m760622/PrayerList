//
//  NoteCollectionViewCell.swift
//  PrayerList
//
//  Created by Devin  on 29/01/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

enum NoteCellStyle {
    case light
    case dark
}

class NoteCollectionViewCell: CB3DSelectCell {
    
    static var resuseIdientifier = "NoteCollectionViewCell"
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var subLabelView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dropShadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 15
        
        dropShadowView.layer.shadowOffset = CGSize(width: 2, height: 6)
        dropShadowView.layer.shadowRadius = 10
        dropShadowView.layer.shadowOpacity = 0.3
        dropShadowView.clipsToBounds = false
        
        label.textColor = Theme.Color.Text
        subLabel.textColor = Theme.Color.Subtitle
    }
    
    func setUp(text: String, subtext: String?, style: NoteCellStyle){
        label.text = text
        
        if let subtext = subtext {
            subLabel.text = subtext
            subLabelView.isHidden = false
        } else {
            subLabelView.isHidden = true
        }
        
        styleCell(style: style)
    }
    
    func styleCell(style: NoteCellStyle){
        containerView.backgroundColor = style == .light ? UIColor.white : UIColor(hexString: "#242424")
        label.textColor = style == .light ? Theme.Color.Text : UIColor.white
        dropShadowView.layer.shadowColor = style == .light ? Theme.Color.dropShadow.cgColor : UIColor(hexString: "#0A0A0A").cgColor
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        let size = contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1), withHorizontalFittingPriority: .required, verticalFittingPriority: verticalFittingPriority)
        
        return size
    }

}
