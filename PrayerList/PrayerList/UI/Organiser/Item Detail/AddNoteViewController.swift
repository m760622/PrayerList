//
//  AddItemViewController.swift
//  PrayerList
//
//  Created by Devin  on 11/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol AddNoteDelegate: class {
    func addItem(detail: String)
}

class AddNoteViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: AddNoteDelegate?
    
    var entry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Note"
        
        tableView.register(UINib(nibName: LargeTextTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: LargeTextTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        if let entry = entry, !entry.isEmpty {
            self.view.endEditing(true)
            delegate?.addItem(detail: entry)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LargeTextTableViewCell.reuseIdentifier, for: indexPath) as! LargeTextTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? LargeTextTableViewCell{
            cell.delegate = self
            cell.textView.becomeFirstResponder()
        }
    }
}

extension AddNoteViewController: LargeTextCellDelegate {
    func textUpdated(text: String?) {
        guard let text = text else { return }
        entry = text
        self.navigationItem.rightBarButtonItem?.isEnabled = !text.isEmpty
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
