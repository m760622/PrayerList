//
//  DaySelectionViewController.swift
//  PrayerList
//
//  Created by Devin  on 18/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

protocol DaySelectionDelegate: class {
    func updated(selectedDays: [DayAlert])
}

enum DayAlert: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var title: String {
        switch(self) {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }
}

class DaySelectionViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: DaySelectionDelegate?
    
    var selectedDays = [DayAlert]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Days"
        
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier:  TextFieldTableViewCell.reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updated(selectedDays: selectedDays)
    }
    
}

extension DaySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DayAlert.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
        let day = DayAlert.allCases[indexPath.row]
        cell.setUp(title: day.title, detail: nil, isEditable: false, indexPath: indexPath)
        cell.accessoryType = selectedDays.contains(day) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let day = DayAlert.allCases[indexPath.row]
        if let index = selectedDays.firstIndex(of: day) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(day)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
             cell.accessoryType = selectedDays.contains(day) ? .checkmark : .none
        }
    }
    
}
