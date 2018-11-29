//
//  PrayerDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class PrayerDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var prayer: PrayerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = prayer.name
    }
}
