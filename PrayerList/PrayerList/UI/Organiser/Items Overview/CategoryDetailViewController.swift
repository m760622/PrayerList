//
//  CategoryDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit
import ContactsUI

class CategoryDetailViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    var category: CategoryModel?
    var groups = [ItemModel]()
    
    var selectedGroup: ItemModel?
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView.instantiate()
        self.view.addSubview(view)
        view.setUp(title: "No Items", subtitle: "There aren't any items for this category", image: UIImage(named: "empty-category"), parentView: self.view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.category?.name ?? ""
        
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ItemOverviewCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ItemOverviewCollectionViewCell.reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tab = self.tabBarController as? TabBarController {
            tab.plus.delegate = self
        }
        
        collectionView.backgroundColor = Theme.Color.Background
        if let oldCategory = self.category {
            self.category = CategoryInterface.retrieveCategory(forID: oldCategory.uuid, context: CoreDataManager.mainContext)
        }
        
        if let groups = category?.items {
            self.groups = groups
            collectionView.reloadData()
        }
        
        if groups.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? UINavigationController {
            if let childVC = destVC.topViewController as? AddItemFormViewController {
                childVC.category = self.category
            } else if let childVC = destVC.topViewController as? CategorySettingsViewController {
                childVC.category = self.category
                childVC.delegate = self
            }
        } else if let dest = segue.destination as? ItemDetailViewController, let group = self.selectedGroup {
            dest.selectedItem = group
        }
    }
    
    func updateGroupsOrder(){
        for (index, group) in groups.enumerated() {
            group.order = index
            ItemInterface.saveGroup(group: group, inContext: CoreDataManager.mainContext)
        }
    }
}

extension CategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemOverviewCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemOverviewCollectionViewCell
        
        cell.setUp(title: groups[indexPath.row].name, detail: "\(groups[indexPath.row].currentNotes.count) Notes", backgroundColor: Theme.Color.cellColor, textColor: Theme.Color.Text, detailTextColor: Theme.Color.Subtitle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedGroup = groups[indexPath.row]
        self.performSegue(withIdentifier: "showGroupDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 30, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = .identity
            }
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.groups[sourceIndexPath.row]
        self.groups.remove(at: sourceIndexPath.row)
        self.groups.insert(movedObject, at: destinationIndexPath.row)
        updateGroupsOrder()
    }
}

extension CategoryDetailViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        guard let catagory = self.category else { return }
        contacts.forEach { contact in
            let group = ItemModel(name: contact.givenName + " " + contact.familyName, order: catagory.items.count)
            group.prayerIds = catagory.prayers.map({$0.uuid})
            category?.items.append(group)
            
        }
        CategoryInterface.saveCategory(category: catagory, inContext: CoreDataManager.mainContext)
        self.collectionView.reloadData()
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
}

extension CategoryDetailViewController: SettingsDelegate {
    func thingDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func nameUpdated(name: String) {
        self.title = name
    }
}

extension CategoryDetailViewController: PlusDelegate {
    func action() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (addGroup) in
            self.performSegue(withIdentifier: "addSingleGroupSegue", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Add From Contacts", style: .default, handler: { (importContacts) in
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            self.present(contactPicker, animated: true, completion: nil)
        }))
        
        if let tab = self.tabBarController as? TabBarController {
            alert.popoverPresentationController?.sourceRect = tab.plus.bounds
            alert.popoverPresentationController?.sourceView = tab.plus
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
