//
//  PrayerSectionViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/01/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class PrayerSectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var category: CategoryModel?
    
    var prayerManager: PrayerSessionManager!
    
    var items = [ItemModel]()
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView.instantiate()
        self.view.addSubview(view)
        view.setUp(title: "No Items", subtitle: "You haven't assigned any items to this prayer yet", image: nil, parentView: self.view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.textColor = UIColor.white
        titleLabel.text = category?.name ?? ""
        
        collectionView.register(UINib(nibName: NoteCollectionViewCell.resuseIdientifier, bundle: nil), forCellWithReuseIdentifier: NoteCollectionViewCell.resuseIdientifier)
        
        collectionView.register(UINib(nibName: PlainHeaderCollectionReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: collectionView.bounds.width - 30, height: 200)
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width - 30, height: 50)
        }

        if let category = self.category {
            items = prayerManager.getItemsForCategory(category: category)
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 45, right: 15)
        
        collectionView.backgroundColor = UIColor.black
        view.backgroundColor = UIColor.black
    }

}

extension PrayerSectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].currentNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.resuseIdientifier, for: indexPath) as! NoteCollectionViewCell
        cell.setUp(text: items[indexPath.section].currentNotes[indexPath.row].name, subtext: nil, style: .dark)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? PlainHeaderCollectionReusableView {
                sectionHeader.setUp(title: items[indexPath.section].name, color: UIColor.white)
                return sectionHeader
            }
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

extension PrayerSectionViewController: Instantiatable {
    static var appStoryboard: AppStoryboard {
        return .prayer
    }
}
