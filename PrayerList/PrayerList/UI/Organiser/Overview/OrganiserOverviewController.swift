//
//  OrganiserOverviewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class OrganiserOverviewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories = [PrayerCategoryModel]()
    var selectedCategory: PrayerCategoryModel?
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        
        collectionView.register(UINib(nibName: PrayerCollectionViewCell.resuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PrayerCollectionViewCell.resuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = CategoryInterface.retrieveAllCategories(inContext: CoreDataManager.mainContext)
        
        collectionView.backgroundColor = Theme.Color.Background
        collectionView.reloadData()
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
    
    func updateCategoryOrder(){
        for (index, category) in categories.enumerated() {
            category.order = index
            CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
        }
    }
    
    func pushToDetial(){
        self.performSegue(withIdentifier: "categoryDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? CategoryDetailViewController, let selectedCategory = self.selectedCategory {
            destVC.category = selectedCategory
        }
    }

}

extension OrganiserOverviewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrayerCollectionViewCell.resuseIdentifier, for: indexPath) as! PrayerCollectionViewCell
        
        cell.setUp(title: categories[indexPath.row].name, backgroundColor: Theme.Color.cellColor, textColor: Theme.Color.Text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        pushToDetial()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 30, height: 80)
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
        let movedObject = self.categories[sourceIndexPath.row]
        self.categories.remove(at: sourceIndexPath.row)
        self.categories.insert(movedObject, at: destinationIndexPath.row)
        updateCategoryOrder()
    }
}
