//
//  GroupItemsCollectionViewCell.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class GroupItemsCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "GroupItemsCollectionViewCell"

    @IBOutlet weak var dropShadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var items = [PrayerItemModel]()
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(UINib(nibName: ItemTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        
        dropShadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        dropShadowView.layer.shadowOffset = CGSize(width: 2, height: 6)
        dropShadowView.layer.shadowRadius = 10
        dropShadowView.layer.shadowOpacity = 0.3
        dropShadowView.clipsToBounds = false
    }
    
    func setUp(items: [PrayerItemModel]) {
        let newItems = items.filter { (item) -> Bool in
            return !self.items.contains(where: {$0.uuid == item.uuid})
        }
        
        tableView.beginUpdates()
        for item in newItems {
            self.items.append(item)
            tableView.insertRows(at: [IndexPath(row: self.items.count - 1, section: 0)], with: .fade)
        }
        tableView.endUpdates()
        tableView.layoutIfNeeded()
        self.heightConstraint.constant = tableView.contentSize.height
    }
}

extension GroupItemsCollectionViewCell: ItemTableCellDelegate {
    func updateTable() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension GroupItemsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as! ItemTableViewCell
        cell.setUp(title: item.name)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}
