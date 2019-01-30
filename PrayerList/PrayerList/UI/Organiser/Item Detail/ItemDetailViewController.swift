//
//  GroupDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedItem: ItemModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedItem.name
        
        collectionView.register(UINib(nibName: NoteCollectionViewCell.resuseIdientifier, bundle: nil), forCellWithReuseIdentifier: NoteCollectionViewCell.resuseIdientifier)
        
        collectionView.register(UINib(nibName: PlainHeaderCollectionReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: collectionView.bounds.width - 30, height: 200)
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width - 30, height: 50)
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        
        if let tab = self.tabBarController as? TabBarController {
            tab.plus.delegate = self
        }
        
        collectionView.backgroundColor = Theme.Color.Background
        
        collectionView.reloadData()
        
        if let tab = self.tabBarController as? TabBarController {
            tab.plus.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UINavigationController {
            if let child = dest.topViewController as? AddNoteViewController {
                child.delegate = self
            }
        } else if let dest = segue.destination as? FullNotesViewController {
            dest.selectedItem = self.selectedItem
        }
    }
}

extension ItemDetailViewController: PlusDelegate {
    func action() {
        self.performSegue(withIdentifier: "addItemSegue", sender: self)
    }
}

extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedItem.currentNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.resuseIdientifier, for: indexPath) as! NoteCollectionViewCell
        let note = self.selectedItem.currentNotes[indexPath.row]
        
        cell.setUp(text: note.name, subtext: DateHelper.getStringFromDate(date: note.dateCreated, format: "eee dd MMM yyyy"), style: .light)
        
//            let shouldShowMoreButton = self.selectedItem.currentNotes.count - 5 > 0
//            cell.setUp(items: Array(self.selectedItem.currentNotes.prefix(15)).map({$0.name}), showActionButton: shouldShowMoreButton, actionButtonTitle: shouldShowMoreButton ? "\(self.selectedItem.currentNotes.count - 5) More" : nil, emptyTitle: "No Notes", emptySubtitle: "You haven't added any notes for \(selectedItem.name)")
//            cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? PlainHeaderCollectionReusableView {
                sectionHeader.setUp(title: "Notes")
                return sectionHeader
            }
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

extension ItemDetailViewController: TableViewCellDelegate {
    func tableDidSizeChange() {
        //collectionView.reloadItems(at: [Inde])
        //collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func buttonAction() {
        performSegue(withIdentifier: "fullNotesSegue", sender: self)
    }
}

extension ItemDetailViewController: AddNoteDelegate {
    func addItem(detail: String) {
        let item = NoteModel(name: detail)
        selectedItem.currentNotes.insert(item, at: 0)
        ItemInterface.saveGroup(group: selectedItem, inContext: CoreDataManager.mainContext)
        
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        }) { (completed) in
            
        }
    }
}
