//
//  GroupDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedGroup: PrayerGroupModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedGroup.name
        
        collectionView.register(UINib(nibName: GroupItemsCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupItemsCollectionViewCell.reuseIdentifier)
        
        collectionView.register(UINib(nibName: PlainHeaderCollectionReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: collectionView.bounds.width - 30, height: 200)
            layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.width, height: 50)
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    func addItem(itemString: String?) {
        guard let itemString = itemString, !itemString.isEmpty else { return }
        let item = PrayerItemModel(name: itemString)
        selectedGroup.currentItems.append(item)
        GroupInterface.saveGroup(group: selectedGroup, inContext: CoreDataManager.mainContext)
        collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
    }
    
    @IBAction func addAction(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "Enter something to prayer about", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] (alertAction) in
            let textField = alert.textFields![0] as UITextField
            self?.addItem(itemString: textField.text)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Thing"
            textField.autocapitalizationType = .sentences
        }
        
        alert.view.tintColor = Theme.Color.PrimaryTint
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension GroupDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupItemsCollectionViewCell.reuseIdentifier, for: indexPath) as! GroupItemsCollectionViewCell
        cell.setUp(items: self.selectedGroup.currentItems)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? PlainHeaderCollectionReusableView {
                if indexPath.section == 0 {
                    sectionHeader.setUp(title: "Current")
                } else if indexPath.section == 1 {
                    sectionHeader.setUp(title: "Prayers")
                }
                return sectionHeader
            }
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
}
