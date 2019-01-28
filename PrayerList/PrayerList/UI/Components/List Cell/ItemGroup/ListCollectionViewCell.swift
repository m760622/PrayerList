//
//  ListCollectionViewCell.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
    func tableDidSizeChange()
    func buttonAction()
}

class ListCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "ListCollectionViewCell"

    @IBOutlet weak var dropShadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moreButtonView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var items = [Any]()
    
    weak var delegate: TableViewCellDelegate?
    
    var placeHolderTitle: String?
    var placeholderSubtitle: String?
    
    lazy var emptyView: EmptyView = {
        let placeholderView = EmptyView.instantiate()
        self.addSubview(placeholderView)
        placeholderView.setUp(title: placeHolderTitle ?? "Empty", subtitle: placeholderSubtitle ?? "", image: nil, parentView: self)
        return placeholderView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(UINib(nibName: ItemTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        
        dropShadowView.layer.shadowColor = Theme.Color.dropShadow.cgColor
        dropShadowView.layer.shadowOffset = CGSize(width: 2, height: 6)
        dropShadowView.layer.shadowRadius = 10
        dropShadowView.layer.shadowOpacity = 0.3
        dropShadowView.clipsToBounds = false
        
        moreButton.backgroundColor = Theme.Color.LightGrey
        moreButton.tintColor = Theme.Color.PrimaryTint
        moreButton.setTitleColor(Theme.Color.PrimaryTint, for: .normal)
        moreButton.layer.cornerRadius = moreButton.bounds.height / 2
        
        titleLabel.textColor = Theme.Color.Text
    }
    
    func setUp(title: String? = nil, items: [Any], showActionButton: Bool, actionButtonTitle: String?, emptyTitle: String?, emptySubtitle: String?) {
        
        self.titleLabel.isHidden = title == nil
        self.titleLabel.text = title
        self.items = items
        tableView.reloadData()
        
        moreButtonView.isHidden = !showActionButton
        moreButton.setTitle(actionButtonTitle, for: .normal)
        
        self.placeHolderTitle = emptyTitle
        self.placeholderSubtitle = emptySubtitle
        
        stackView.isHidden = items.isEmpty
        emptyView.isHidden = !items.isEmpty
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        self.heightConstraint.constant = !items.isEmpty ? tableView.contentSize.height : 100
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    @IBAction func moreAction(_ sender: Any) {
        delegate?.buttonAction()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        let size = contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1), withHorizontalFittingPriority: .required, verticalFittingPriority: verticalFittingPriority)

        return size
    }
}

extension ListCollectionViewCell: ItemTableCellDelegate {
    func updateTable() {
        tableView.beginUpdates()
        tableView.endUpdates()
        delegate?.tableDidSizeChange()
    }
}

extension ListCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as! ItemTableViewCell
        if let item = item as? NoteModel {
            cell.setUp(title: item.name)
        } else if let item = item as? String {
            cell.setUp(title: item)
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let item = items[indexPath.row]
//        items.remove(at: indexPath.row)
//        ItemInterface.deleteItem(item: item, inContext: CoreDataManager.mainContext)
//
//        tableView.beginUpdates()
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
//        tableView.layoutIfNeeded()
//        self.heightConstraint.constant = tableView.contentSize.height
//        delegate?.tableDidSizeChange()
    }

}
