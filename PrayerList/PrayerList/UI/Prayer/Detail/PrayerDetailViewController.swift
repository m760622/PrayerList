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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = prayer.name
        
        collectionView.register(UINib(nibName: ListCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        self.collectionView.backgroundColor = Theme.Color.Background
        self.title = prayer.name
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
        let items = categories[indexPath.section].retrieveItemsForPrayer(prayer: self.prayer)
        if let cell = cell as? ListCollectionViewCell {
            cell.setUp(items: items.map({$0.currentItems}), showActionButton: false, actionButtonTitle: nil, emptyTitle: nil, emptySubtitle: nil)
        }
    }
}
