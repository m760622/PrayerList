//
//  PrayerSettingsTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol CellTextDelegate: class {
    func textChanged(text: String?, item: PrayerSettingsTableItem)
}

class PrayerSettingsTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "PrayerSettingsTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var item: PrayerSettingsTableItem!
    weak var delegate: CellTextDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(title: String, detail: String?, isEditable: Bool, item: PrayerSettingsTableItem) {
        self.item = item
        self.titleLabel.text = title
        self.textField.text = detail
        self.textField.isUserInteractionEnabled = isEditable
        
        if item == .delete {
            self.titleLabel.textColor = Theme.Color.Error
        } else {
            self.titleLabel.textColor = Theme.Color.Text
        }
        self.textField.textColor = Theme.Color.Subtitle
    }
    
}

extension PrayerSettingsTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textAlignment = .left
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textChanged(text: textField.text, item: self.item)
        textField.textAlignment = .right
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
