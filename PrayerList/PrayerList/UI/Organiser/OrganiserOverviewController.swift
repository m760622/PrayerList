//
//  OrganiserOverviewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol PrayerSettingsDelegate: class {
    func prayerDeleted(prayer: PrayerModel)
}

class OrganiserOverviewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories = [CategoryModel]()
    var selectedCategory: CategoryModel?
    
    var prayers = [PrayerModel]()
    var selectedPrayer: PrayerModel?
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        
        collectionView.register(UINib(nibName: PrayerCollectionViewCell.resuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PrayerCollectionViewCell.resuseIdentifier)
        
        collectionView.register(UINib(nibName: CategoryOverviewCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CategoryOverviewCollectionViewCell.reuseIdentifier)
        
        collectionView.register(UINib(nibName: PlainHeaderCollectionReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width - 30, height: 50)
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        plusVisibilityDelegate?.hide()
        
        categories = CategoryInterface.retrieveAllCategories(inContext: CoreDataManager.mainContext)
        prayers = PrayerInterface.retrieveAllPrayers(inContext: CoreDataManager.mainContext)
        
        collectionView.backgroundColor = Theme.Color.Background
        collectionView.reloadData()
        
        if selectedCategory == nil && !categories.isEmpty {
            let initialIndexPath = IndexPath(row: 0, section: 0)
            self.collectionView.selectItem(at: initialIndexPath, animated: true, scrollPosition: .top)
            selectedCategory = categories.first
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.performSegue(withIdentifier: "categoryDetailSegue", sender: self)
            }
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
            
        } else if let destVC = segue.destination as? UINavigationController, let childVC  = destVC.topViewController as? CategoryDetailViewController {
            childVC.category = selectedCategory
            childVC.title = selectedCategory?.name
        }
    }
    
}

extension OrganiserOverviewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return categories.count
        } else {
            return prayers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryOverviewCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryOverviewCollectionViewCell
            
            cell.setUp(title: categories[indexPath.row].name, detail: "\(categories[indexPath.row].items.count) item\(categories[indexPath.row].items.count == 1 ? "" : "s")")
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrayerCollectionViewCell.resuseIdentifier, for: indexPath) as! PrayerCollectionViewCell
            
            cell.setUp(title: prayers[indexPath.row].name, backgroundColor: .white, textColor: Theme.Color.PrimaryTint, fontSize: 18, cornerRadius: 15)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedCategory = categories[indexPath.row]
            pushToDetial()
        } else if indexPath.section == 1 {
            
            let storyboard = UIStoryboard(name: AppStoryboard.prayerOrganiser.rawValue, bundle: nil)
            let prayerSettingsNavVC = storyboard.instantiateViewController(withIdentifier: "PrayerSettingsNavigationController") as! UINavigationController
            if let prayerSettingsVC = prayerSettingsNavVC.topViewController as? PrayerSettingsViewController {
                prayerSettingsVC.selectedPrayer = prayers[indexPath.row]
                prayerSettingsVC.delegate = self
            }
            self.present(prayerSettingsNavVC, animated: true, completion: nil)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let count: CGFloat = 3
            let availableSpace = collectionView.bounds.width - ((count + 1) * 15)
            let width = availableSpace / count
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: collectionView.bounds.width - 30, height: 50)
        }
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
        return indexPath.section == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if(sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
            let movedObject = self.categories[sourceIndexPath.row]
            self.categories.remove(at: sourceIndexPath.row)
            self.categories.insert(movedObject, at: destinationIndexPath.row)
            updateCategoryOrder()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if (originalIndexPath.section != proposedIndexPath.section) {
            return originalIndexPath
        }
        return proposedIndexPath
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlainHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? PlainHeaderCollectionReusableView {
                if indexPath.section == 0 {
                    sectionHeader.setUp(title: "Categories", section: indexPath.section, buttonVisible: true)
                } else {
                    sectionHeader.setUp(title: "Prayers", section: indexPath.section, buttonVisible: true)
                }
                sectionHeader.delegate = self
                return sectionHeader
            }
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
}

extension OrganiserOverviewController: HeaderActionDelegate {
    func action(section: Int){
        if section == 0 {
            performSegue(withIdentifier: "addCategorySegue", sender: nil)
        } else if section == 1 {
            let storyboard = UIStoryboard(name: AppStoryboard.prayerOrganiser.rawValue, bundle: nil)
            let addPrayerVC = storyboard.instantiateViewController(withIdentifier: "AddPrayerNavigationController")
            
            self.present(addPrayerVC, animated: true, completion: nil)
        }
    }
}

extension OrganiserOverviewController: PrayerSettingsDelegate {
    func prayerDeleted(prayer: PrayerModel) {
        if let index = prayers.firstIndex(where: {$0.uuid == prayer.uuid}) {
            prayers.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(row: index, section: 1)])
        }
    }
    
}
