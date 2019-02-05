//
//  GroupOverviewCollectionViewCell.swift
//  PrayerList
//
//  Created by Devin  on 5/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class GroupOverviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    
    static var reuseIdentifier: String = "GroupOverviewCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(textSnippits: [String]){
        for (index, textSnippit) in textSnippits.enumerated() {
            
            let snippitView = SnippitView.instantiate()
            snippitView.setUp(text: textSnippit, textColor: .white, backgroundColor: Theme.Color.Green.withAlphaComponent(0.2))
            
            if index < 3 {
                topStack.addArrangedSubview(snippitView)
            } else {
                bottomStack.addArrangedSubview(snippitView)
            }
            
            snippitView.layout()
        }
    }
    
    override func prepareForReuse() {
        for view in topStack.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for view in bottomStack.arrangedSubviews {
            view.removeFromSuperview()
        }
    }

}
