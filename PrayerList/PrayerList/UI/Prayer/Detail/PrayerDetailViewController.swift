//
//  PrayerDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
    func thingDeleted()
    func nameUpdated(name: String)
}

class PrayerDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var prayer: PrayerModel!
    
    var categories = [CategoryModel]()
    
    var items = [ItemModel]()
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView.instantiate()
        self.view.addSubview(view)
        view.setUp(title: "No Items", subtitle: "You haven't assigned any items to your prayer", image: nil, parentView: self.view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = prayer.name
        
        collectionView.register(UINib(nibName: ListCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        
         collectionView.register(UINib(nibName: PlainHeaderCollectionReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: collectionView.bounds.width - 30, height: 100)
            layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.width - 30, height: 50)
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.backgroundColor = Theme.Color.Background
        self.title = prayer.name
        
        sortData()
        
        emptyView.isHidden = !prayer.itemIDs.isEmpty
        collectionView.isHidden = prayer.itemIDs.isEmpty
    }
    
    func sortData(){
        categories = CategoryInterface.retrieveAllCategories(inContext: CoreDataManager.mainContext).filter({$0.retrieveItemsForPrayer(prayer: prayer).count > 0})
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PrayerSettingsViewController {
            destVC.prayer = self.prayer
            destVC.delegate = self
        } else if let destVC = segue.destination as? UINavigationController {
            if let childVC = destVC.viewControllers.first as? PrayerSettingsViewController {
                childVC.prayer = self.prayer
                childVC.delegate = self
            }
        }
    }
    
    @IBAction func completeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PrayerDetailViewController: SettingsDelegate {
    func thingDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func nameUpdated(name: String) {
        self.title = name
    }
}

extension PrayerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].retrieveItemsForPrayer(prayer: self.prayer).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = categories[indexPath.section].retrieveItemsForPrayer(prayer: self.prayer)[indexPath.row]
        if let cell = cell as? ListCollectionViewCell {
            cell.setUp(title: item.name, items: item.currentNotes, showActionButton: false, actionButtonTitle: nil, emptyTitle: nil, emptySubtitle: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? PlainHeaderCollectionReusableView {
                sectionHeader.setUp(title: categories[indexPath.section].name, color: Theme.Color.PrimaryTint)
                return sectionHeader
            }
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
}
