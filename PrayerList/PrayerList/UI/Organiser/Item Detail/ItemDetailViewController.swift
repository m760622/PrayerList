//
//  GroupDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 10/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class ItemDetailViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView.instantiate()
        self.view.addSubview(view)
        view.setUp(title: "Add Notes", subtitle: "Add notes to this item. Notes will be visible when you enter a prayer", image: UIImage(named: "EmptyNote"), parentView: self.view)
        return view
    }()
    
    var selectedItem: ItemModel!
    
    var selectedNote: NoteModel?

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
        
        plusVisibilityDelegate?.show()
        
        if let tab = self.tabBarController as? TabBarController {
            tab.plus.delegate = self
        }
        
        collectionView.backgroundColor = Theme.Color.Background
        
        collectionView.reloadData()
        
        updateView()
        
        if let tab = self.tabBarController as? TabBarController {
            tab.plus.delegate = self
        }
    }
    
    func updateView(){
        if selectedItem.currentNotes.isEmpty {
            collectionView.isHidden = true
            emptyView.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UINavigationController {
            if let child = dest.topViewController as? AddNoteViewController {
                child.delegate = self
                child.note = selectedNote
            } else if let child = dest.topViewController as? ItemSettingsViewController {
                child.item = selectedItem
                child.delegate = self
            }
        }
        
        selectedNote = nil
    }
}

extension ItemDetailViewController: PlusDelegate {
    func action() {
        self.performSegue(withIdentifier: "addItemSegue", sender: self)
    }
}

extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        
        return self.selectedItem.currentNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.resuseIdientifier, for: indexPath) as! NoteCollectionViewCell
            let note = self.selectedItem.currentNotes[indexPath.row]
            
            cell.setUp(text: note.name, subtext: DateHelper.timeAgoSinceDate(date: note.dateCreated as NSDate, numericDates: true), style: .light)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.resuseIdientifier, for: indexPath) as! NoteCollectionViewCell
            let note = self.selectedItem.currentNotes[indexPath.row]
            
            cell.setUp(text: note.name, subtext: DateHelper.timeAgoSinceDate(date: note.dateCreated as NSDate, numericDates: true), style: .light)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedNote = selectedItem.currentNotes[indexPath.row]
            self.performSegue(withIdentifier: "addItemSegue", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? PlainHeaderCollectionReusableView {
                if indexPath.section == 0 {
                    sectionHeader.setUp(title: "Details", section: indexPath.section)
                } else {
                    sectionHeader.setUp(title: "Notes", section: indexPath.section)
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
    func deleteNote(note: NoteModel) {
        NoteInterface.deleteItem(item: note, inContext: CoreDataManager.mainContext)
        
        if let index = selectedItem.currentNotes.firstIndex(where: {$0.uuid == note.uuid}) {
            selectedItem.currentNotes.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(row: index, section: 1)])
        }
    }
    
    func updateNote(note: NoteModel) {
        NoteInterface.saveItem(item: note, inContext: CoreDataManager.mainContext)
        
        if let index = selectedItem.currentNotes.firstIndex(where: {$0.uuid == note.uuid}) {
            collectionView.reloadItems(at: [IndexPath(row: index, section: 1)])
        }
    }
    
    func addItem(detail: String) {
        let item = NoteModel(name: detail)
        selectedItem.currentNotes.insert(item, at: 0)
        ItemInterface.saveGroup(group: selectedItem, inContext: CoreDataManager.mainContext)
        
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [IndexPath(row: 0, section: 1)])
        }) { (completed) in
            
        }
        
        updateView()
    }
}

extension ItemDetailViewController: SettingsDelegate {
    func thingDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func nameUpdated(name: String) {
        self.title = name
    }
}
