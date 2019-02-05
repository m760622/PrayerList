//
//  ButtonTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 5/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "ButtonTableViewCell"

    @IBOutlet weak var buttonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(buttonText: String, textColor: UIColor) {
        buttonLabel.text = buttonText
        buttonLabel.textColor = textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
