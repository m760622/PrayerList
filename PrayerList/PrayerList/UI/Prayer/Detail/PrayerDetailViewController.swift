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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = prayer.name
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
}

extension PrayerDetailViewController: SettingsDelegate {
    func thingDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func nameUpdated(name: String) {
        self.title = name
    }
}
