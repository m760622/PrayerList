//
//  PrayerDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol PrayerSettingsDelegate: class {
    func prayerDeleted()
}

class PrayerDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var prayer: PrayerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

extension PrayerDetailViewController: PrayerSettingsDelegate {
    func prayerDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
}
