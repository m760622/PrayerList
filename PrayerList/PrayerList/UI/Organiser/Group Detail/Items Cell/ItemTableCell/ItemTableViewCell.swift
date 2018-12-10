//
//  ItemTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol ItemTableCellDelegate: class {
    func updateTable()
}

class ItemTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "ItemTableViewCell"
    
    weak var delegate: ItemTableCellDelegate?

    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(title: String) {
        self.itemLabel.text = title
        delegate?.updateTable()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
