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
    func updateNote(note: NoteModel)
    func deleteNote(note: NoteModel)
}

class AddNoteViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: AddNoteDelegate?
    
    var note: NoteModel?
    
    var addButton: UIBarButtonItem!
    
    var entry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = note == nil ? "Add Note" : "Note"
        
        tableView.register(UINib(nibName: LargeTextTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: LargeTextTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: ButtonTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        addButton = UIBarButtonItem(title: note == nil ? "Add" : "Update", style: .done, target: self, action: #selector(addAction))
        
        addButton.isEnabled = false
        
        entry = note?.name
        
        navigationItem.rightBarButtonItem = addButton
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addAction(){
        if let entry = entry, !entry.isEmpty {
            if let note = note {
                note.name = entry
                delegate?.updateNote(note: note)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.view.endEditing(true)
                delegate?.addItem(detail: entry)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension AddNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return note == nil ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LargeTextTableViewCell.reuseIdentifier, for: indexPath) as! LargeTextTableViewCell
            cell.textView.text = entry//note?.name
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
            cell.setUp(buttonText: "Delete", textColor: Theme.Color.Red)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            if let note = note {
                delegate?.deleteNote(note: note)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? LargeTextTableViewCell {
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
        //tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.endUpdates()
    }
}
