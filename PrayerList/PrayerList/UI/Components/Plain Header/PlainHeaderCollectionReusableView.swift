//
//  PlainHeaderCollectionReusableView.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class PlainHeaderCollectionReusableView: UICollectionReusableView {
    
    static var reuseIdentifier: String = "PlainHeaderCollectionReusableView"

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(title: String) {
        self.label.text = title
    }
    
}
