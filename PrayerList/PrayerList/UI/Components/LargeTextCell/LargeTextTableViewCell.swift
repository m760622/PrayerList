//
//  LargeTextTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 15/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol LargeTextCellDelegate: class {
    func textUpdated(text: String?)
}

class LargeTextTableViewCell: UITableViewCell {
    
    static var reuseIdentifier = "LargeTextTableViewCell"
    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: LargeTextCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
        textView.sizeToFit()
    }
    
    func setUp(text: String) {
        textView.text = text
        //delegate?.textUpdated(text: textView.text)
    }

}

extension LargeTextTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textUpdated(text: textView.text)
    }
}
