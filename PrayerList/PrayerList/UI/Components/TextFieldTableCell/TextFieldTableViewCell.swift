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
    
    var toolBar: UIToolbar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        textField.addTarget(self, action: #selector(updateValues(_:)), for: UIControl.Event.editingChanged)
        
        toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))]
        toolBar.sizeToFit()
    }

    @objc func donePressed () {
        textField.resignFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUp(title: String, detail: String?, placeholder: String? = nil, isEditable: Bool, indexPath: IndexPath, titleColor: UIColor = Theme.Color.Text, detailColor: UIColor = Theme.Color.Text, keyboardType: UIKeyboardType = .alphabet) {
        self.indexPath = indexPath
        self.titleLabel.text = title
        self.textField.text = detail
        self.textField.placeholder = placeholder
        self.textField.isUserInteractionEnabled = isEditable
        self.textField.keyboardType = keyboardType
        
        if keyboardType == .numberPad {
            textField.inputAccessoryView = toolBar
        } else {
            textField.inputAccessoryView = nil
        }
        
        self.titleLabel.textColor = titleColor
        self.textField.textColor = detailColor
    }
    
     @objc func updateValues(_ textField: UITextField) {
        delegate?.textChanged(text: textField.text, indexPath: self.indexPath)
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
