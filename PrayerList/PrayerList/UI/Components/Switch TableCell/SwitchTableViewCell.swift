//
//  SwitchTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 6/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func switchToggled(indexPath: IndexPath)
}

class SwitchTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "SwitchTableViewCell"

    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    var indexPath: IndexPath!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = Theme.Color.Text
        switchControl.onTintColor = Theme.Color.PrimaryTint
        self.selectionStyle = .none
    }
    
    func setUp(title: String, switchState: Bool, indexPath: IndexPath) {
        titleLabel.text = title
        switchControl.isOn = switchState
        self.indexPath = indexPath
    }

    @IBAction func switchToggled(_ sender: Any) {
        delegate?.switchToggled(indexPath: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

