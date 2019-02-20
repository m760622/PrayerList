//
//  ReminderTimeSelectionViewController.swift
//  PrayerList
//
//  Created by Devin  on 18/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

enum TimeAlert: Int, CaseIterable {
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

protocol ReminderTimeDelegate: class {
    func reminderTimeUpdates(timeAlert: TimeAlert)
}

class ReminderTimeSelectionViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ReminderTimeDelegate?
    
    var selectedTime: TimeAlert!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Alert"
        
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier:  TextFieldTableViewCell.reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reminderTimeUpdates(timeAlert: selectedTime)
    }

}

extension ReminderTimeSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeAlert.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
        let alert = TimeAlert.allCases[indexPath.row]
        cell.setUp(title: alert.title, detail: nil, isEditable: false, indexPath: indexPath)
        cell.accessoryType = selectedTime == alert ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = TimeAlert.allCases[indexPath.row]
        if alert != selectedTime {
            
            if let oldIndex = TimeAlert.allCases.firstIndex(of: selectedTime) {
                if let oldCell = tableView.cellForRow(at: IndexPath(row: oldIndex, section: 0)) {
                    oldCell.accessoryType = .none
                }
            }
            
            selectedTime = alert
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
        }
    }
    
}

