//
//  PrayerSettingsTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class PrayerSettingsTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "PrayerSettingsTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(title: String) {
        self.titleLabel.text = title
        self.accessoryType = .disclosureIndicator
    }
    
}
