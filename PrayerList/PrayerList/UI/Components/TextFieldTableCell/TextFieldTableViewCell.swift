//
//  PrayerSettingsTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol CellTextDelegate: class {
    func textChanged(text: String?, indexPath: IndexPath)
}

class TextFieldTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "TextFieldTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var indexPath: IndexPath!
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
    
    func setUp(title: String, detail: String?, placeholder: String? = nil, isEditable: Bool, indexPath: IndexPath, titleColor: UIColor = Theme.Color.Text, detailColor: UIColor = Theme.Color.Text) {
        self.indexPath = indexPath
        self.titleLabel.text = title
        self.textField.text = detail
        self.textField.placeholder = placeholder
        self.textField.isUserInteractionEnabled = isEditable
        
        self.titleLabel.textColor = titleColor
        self.textField.textColor = detailColor
    }
    
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textAlignment = .left
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textChanged(text: textField.text, indexPath: self.indexPath)
        textField.textAlignment = .right
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
