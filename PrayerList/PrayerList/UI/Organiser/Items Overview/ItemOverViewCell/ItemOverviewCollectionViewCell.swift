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
    @IBOutlet weak var tickView: UIView!
    @IBOutlet weak var tickViewContainer: UIView!
    @IBOutlet weak var tickImage: UIImageView!
    
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
        
        tickView.clipsToBounds = true
        tickView.layer.cornerRadius = tickView.bounds.width / 2
        tickView.backgroundColor = Theme.Color.Green
        
        tickViewContainer.layer.shadowColor = Theme.Color.Green.withAlphaComponent(0.3).cgColor
        tickViewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        tickViewContainer.layer.shadowRadius = 5
        tickViewContainer.layer.shadowOpacity = 0.9
        tickImage.tintColor = UIColor.white
    }
    
    func setUp(title: String, searchText: String?, detail: String, backgroundColor: UIColor, textColor: UIColor, detailTextColor: UIColor, tickVisble: Bool = false){
        
        if let searchText = searchText {
            showSearch(searchString: searchText, title: title)
        } else {
            titleLabel.text = title
            titleLabel.textColor = textColor
        }
        
        detailLabel.text = detail
        detailLabel.textColor = detailTextColor
        dropshadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        
        tickViewContainer.isHidden = !tickVisble
        
        containerView.backgroundColor = backgroundColor
    }
    
    func showSearch(searchString: String, title: String){
        titleLabel.attributedText = generateAttributedString(with: searchString, targetString: title)
    }
    
    func generateAttributedString(with searchTerm: String, targetString: String) -> NSAttributedString? {
        
        let attributedString = NSMutableAttributedString(string: targetString)
        do {
            let regex = try NSRegularExpression(pattern: searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
            let range = NSRange(location: 0, length: targetString.utf16.count)
            
            let color = Theme.nightMode ? Theme.Color.PrimaryTint.withAlphaComponent(0.8) : Theme.Color.PrimaryTint.withAlphaComponent(0.6)
            
            for match in regex.matches(in: targetString.folding(options: .diacriticInsensitive, locale: .current), options: .withTransparentBounds, range: range) {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: match.range)
            }
            
            return attributedString
        } catch {
            NSLog("Error creating regular expresion: \(error)")
            return nil
        }
    }

}
