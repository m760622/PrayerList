//
//  AddNoteTableViewCell.swift
//  PrayerList
//
//  Created by Devin  on 30/01/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class AddNoteTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "AddNoteTableViewCell"

    @IBOutlet weak var addPromptStackView: UIStackView!
    @IBOutlet weak var addPromtLabel: UILabel!
    @IBOutlet weak var addPromptImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addPromptImage.layer.cornerRadius = addPromptImage.bounds.height / 2
        addPromptImage.backgroundColor = Theme.Color.PrimaryTint
        addPromptImage.tintColor = UIColor.white
    }
    
    func setUp(promptText: String){
        addPromtLabel.text = promptText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
