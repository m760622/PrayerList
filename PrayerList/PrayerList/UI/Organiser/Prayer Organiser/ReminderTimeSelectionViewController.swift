//
//  ReminderTimeSelectionViewController.swift
//  PrayerList
//
//  Created by Devin  on 18/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

enum TimeAlert: Int {
    case atTime = 0
    case fiveBefore = 5
    case tenBefore = 10
    case fifteenBefore = 15
    case thirtyBefore = 30
    case sixtyBefore = 60
    
    var title: String {
        switch self {
        case .atTime:
            return "At Time"
        case .fiveBefore:
            return "5 Minutes Before"
        case .tenBefore:
             return "10 Minutes Before"
        case .fifteenBefore:
             return "15 Minutes Before"
        case .thirtyBefore:
             return "30 Minutes Before"
        case .sixtyBefore:
             return "60 Minutes Before"
        }
    }
}

class ReminderTimeSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
