//
//  DateSelectionCell.swift
//  Planner
//
//  Created by Devin  on 25/05/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {
    func selectedDate(date: Date)
}

class DateSelectionCell: UITableViewCell {
    
    static var reuseIdentifier: String = "DateSelectionCell"

    @IBOutlet weak var picker: UIDatePicker!
    weak var delegate: DatePickerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = Theme.Color.Background
        picker.backgroundColor = Theme.Color.Background
        
        picker.setValue(Theme.Color.Text, forKeyPath: "textColor")
        picker.setValue(false, forKeyPath: "highlightsToday")
    }

    @IBAction func valueChange(_ sender: Any) {
        delegate.selectedDate(date: picker.date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
