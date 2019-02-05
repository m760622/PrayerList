//
//  AddGroupFormViewController.swift
//  PrayerList
//
//  Created by Devin  on 1/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

enum GroupFormCell {
    case name
    case notes
    
    static var sections: [GroupFormCell] {
        return [.name,.notes]
    }
}

class AddItemFormViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var category: CategoryModel!
    var selectedPrayers = [PrayerModel]()
    var groupName: String?
    
    var notes = [NoteModel]()
    var editingNoteUUID: String?
    
    var isFreshLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: AddNoteTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AddNoteTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: LargeTextTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: LargeTextTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 44
        selectedPrayers = category.prayers
        self.updateNavButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if isFreshLoad {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell {
                cell.textField.becomeFirstResponder()
            }
            
            isFreshLoad = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func setUpItem(){
        if let name = groupName {
            let newItem = ItemModel(name: name, order: category.items.count)
            newItem.currentNotes = notes.filter({$0.name != ""})
            category.items.append(newItem)
            CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
        }
    }
    
    func validateInput() -> Bool {
        if groupName != nil {
            return true
        }
        return false
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        if validateInput() {
            setUpItem()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PrayerSelectionViewController {
            destVC.selectedPrayers = self.selectedPrayers
            destVC.delegate = self
        }
    }
    
    func updateNavButtons(){
        if let text = self.groupName, !text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

extension AddItemFormViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GroupFormCell.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch GroupFormCell.sections[section] {
        case .name:
            return 1
        case .notes:
            return notes.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = GroupFormCell.sections[indexPath.section]
        switch item {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.setUp(title: "Title", detail: self.groupName, placeholder: "Add title", isEditable: true, indexPath: indexPath)
            cell.accessoryType = .none
            return cell
        case .notes:
            if notes.isEmpty || indexPath.row == notes.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: AddNoteTableViewCell.reuseIdentifier, for: indexPath) as! AddNoteTableViewCell
                cell.selectionStyle = .none
                cell.setUp(promptText: "Add Note")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LargeTextTableViewCell.reuseIdentifier, for: indexPath) as! LargeTextTableViewCell
                cell.delegate = self
                let note = notes[indexPath.row]
                cell.setUp(text: note.name)
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Top Left Right Corners
        let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shapeLayerTop = CAShapeLayer()
        shapeLayerTop.frame = cell.bounds
        shapeLayerTop.path = maskPathTop.cgPath
        
        //Bottom Left Right Corners
        let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shapeLayerBottom = CAShapeLayer()
        shapeLayerBottom.frame = cell.bounds
        shapeLayerBottom.path = maskPathBottom.cgPath
        
        //All Corners
        let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shapeLayerAll = CAShapeLayer()
        shapeLayerAll.frame = cell.bounds
        shapeLayerAll.path = maskPathAll.cgPath
        
        if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
        {
            cell.layer.mask = shapeLayerAll
        }
        else if (indexPath.row == 0)
        {
            cell.layer.mask = shapeLayerTop
        }
        else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
        {
            cell.layer.mask = shapeLayerBottom
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = GroupFormCell.sections[indexPath.section]
        switch item {
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        case .notes:
            var indexForResponse = indexPath
            if notes.isEmpty || indexPath.row == notes.count {
                let note = NoteModel(name: "")
                notes.append(note)
                
                indexForResponse = IndexPath(row: notes.count - 1, section: 1)
                tableView.beginUpdates()
                tableView.insertRows(at: [indexForResponse], with: .automatic)
                tableView.endUpdates()
                
                tableView.beginUpdates()
                tableView.reloadRows(at: [IndexPath(row: notes.count, section: 1)], with: .fade)
                tableView.endUpdates()
            }
            
            editingNoteUUID = notes[indexForResponse.row].uuid
            if let cell = tableView.cellForRow(at: indexForResponse) as? LargeTextTableViewCell {
                cell.textView.becomeFirstResponder()
            }
        }
    }
}

extension AddItemFormViewController: LargeTextCellDelegate {
    func textUpdated(text: String?) {
        guard let text = text else { return }
        guard let editingNoteUUID = editingNoteUUID else { return }
        notes.first(where: {$0.uuid == editingNoteUUID})?.name = text
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension AddItemFormViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        let item = GroupFormCell.sections[indexPath.section]
        switch item {
        case .name:
            groupName = text
            self.updateNavButtons()
        case .notes:
            print("what in the world?")
        }
    }
    
}

extension AddItemFormViewController: PrayerSelectionDelegate {
    func prayersSelected(prayers: [PrayerModel]) {
        self.selectedPrayers = prayers
    }
}
