//
//  PrayerViewController.swift
//  PrayerList
//
//  Created by Devin  on 30/01/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class PrayerViewController: UIViewController {
    
    @IBOutlet weak var pageCountView: UIView!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    var prayer: PrayerModel!
    
    var completeButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        completeButton = UIBarButtonItem(title: "Complete", style: .done, target: self, action: #selector(doneAction))
        self.view.backgroundColor = UIColor.black
        
        if prayer.categoryIds.count == 1 {
            self.navigationItem.rightBarButtonItem = completeButton
        }
        
        if !prayer.categoryIds.isEmpty {
            setUpPageCount()
        } else {
            pageCountView.isHidden = true
        }
    }
    
    func setUpPageCount(){
        pageCountView.layer.cornerRadius = pageCountView.bounds.height / 2
        pageCountView.backgroundColor = UIColor(hexString: "#242424")
        pageCountLabel.textColor = Theme.Color.Subtitle
        pageCountLabel.text = "\(1) of \(prayer.categoryIds.count)"
        
        pageCountView.layer.shadowOffset = CGSize(width: 2, height: 6)
        pageCountView.layer.shadowRadius = 10
        pageCountView.layer.shadowOpacity = 0.3
        pageCountView.layer.shadowColor = UIColor(hexString: "#0A0A0A").cgColor
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PrayerPageViewController {
            dest.prayer = self.prayer
            dest.progressDelegate = self
        }
    }
    
    @objc func doneAction(){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PrayerViewController: PrayerProgressDelegate {
    func progressUpdated(categoriesCompleted: Int) {
         pageCountLabel.text = "\(categoriesCompleted) of \(prayer.categoryIds.count)"
        if categoriesCompleted == prayer.categoryIds.count {
            self.navigationItem.rightBarButtonItem = completeButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}
