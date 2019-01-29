//
//  FullNotesViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/01/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class FullNotesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedItem: ItemModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notes"
        tableView.register(UINib(nibName: ItemTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
    }

}

extension FullNotesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItem.currentNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as! ItemTableViewCell
        
        cell.setUp(title: selectedItem.currentNotes[indexPath.row].name)
        return cell
    }
    
    
}
