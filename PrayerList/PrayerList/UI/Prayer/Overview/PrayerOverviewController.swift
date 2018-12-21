//
//  PrayerOverviewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class PrayerOverviewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var prayers = [PrayerModel]()
    
    var selectedPrayer: PrayerModel?
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PrayerCollectionViewCell.resuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PrayerCollectionViewCell.resuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plusVisibilityDelegate?.hide()
        
        prayers = PrayerInterface.retrieveAllPrayers(inContext: CoreDataManager.mainContext)
        
        collectionView.backgroundColor = Theme.Color.Background
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        plusVisibilityDelegate?.show()
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
    
    func pushToDetial(){
        self.performSegue(withIdentifier: "prayerDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PrayerDetailViewController, let selectedPrayer = self.selectedPrayer {
            destVC.prayer = selectedPrayer
        }
    }
    
    func updatePrayerOrder(){
        for (index, prayer) in prayers.enumerated() {
            prayer.order = index
            PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
        }
    }
    
    func addPrayer(name: String?) {
        guard let name = name else { return }
        
        let prayer = PrayerModel(name: name, order: prayers.count)
        prayers.append(prayer)
        collectionView.insertItems(at: [IndexPath(row: prayers.count - 1, section: 0)])
        PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
    }
}

extension PrayerOverviewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrayerCollectionViewCell.resuseIdentifier, for: indexPath) as! PrayerCollectionViewCell
        
        cell.setUp(title: prayers[indexPath.row].name, backgroundColor: Theme.Color.PrimaryTint, textColor: UIColor.white)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPrayer = prayers[indexPath.row]
        pushToDetial()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 30, height: 100)
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
        let movedObject = self.prayers[sourceIndexPath.row]
        self.prayers.remove(at: sourceIndexPath.row)
        self.prayers.insert(movedObject, at: destinationIndexPath.row)
        updatePrayerOrder()
    }
}

extension PrayerOverviewController: PlusDelegate {
    func action() {
        let alert = UIAlertController(title: "Add Prayer", message: "Enter the name of your prayer", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] (alertAction) in
            let textField = alert.textFields![0] as UITextField
            self?.addPrayer(name: textField.text)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
        }
        
        alert.view.tintColor = Theme.Color.PrimaryTint
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
