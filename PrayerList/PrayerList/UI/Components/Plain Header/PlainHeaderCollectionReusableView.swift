//
//  PlainHeaderCollectionReusableView.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol HeaderActionDelegate: class {
    func action(section: Int)
}

class PlainHeaderCollectionReusableView: UICollectionReusableView {
    
    static var reuseIdentifier: String = "PlainHeaderCollectionReusableView"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var section: Int!
    
    weak var delegate: HeaderActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(title: String, color: UIColor = Theme.Color.Text, section: Int, buttonVisible: Bool = false) {
        self.label.text = title
        self.label.textColor = color
        self.section = section
        self.button.isHidden = !buttonVisible
        
        self.layoutIfNeeded()
        self.button.backgroundColor = Theme.Color.LightGrey
        self.button.clipsToBounds = true
        self.button.layer.cornerRadius = self.button.bounds.height / 2
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.action(section: section)
    }
}
