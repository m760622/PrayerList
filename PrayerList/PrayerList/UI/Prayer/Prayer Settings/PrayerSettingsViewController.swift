//
//  PrayerSettingsViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class PrayerSettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    var prayers = [PrayerModel]()
    
    var selectedPrayer: PrayerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: PrayerSettingsTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PrayerSettingsTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = Theme.Color.Background
        prayers = PrayerInterface.retrieveAllPrayers(inContext: CoreDataManager.mainContext)
        tableView.reloadData()
        
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addButton.tintColor = UIColor.white
        addButton.backgroundColor = Theme.Color.PrimaryTint
        editButton.title = "Edit"
    }
    
    @IBAction func addAction(_ sender: Any) {
        let alert = UIAlertController(title: "Add Prayer", message: "Enter the name of your prayer", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] (alertAction) in
            let textField = alert.textFields![0] as UITextField
            self?.addPrayer(name: textField.text)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
        }
        
        alert.view.tintColor = Theme.Color.PrimaryTint
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)

    }
    
    func addPrayer(name: String?) {
        guard let name = name else { return }
        
        let prayer = PrayerModel(name: name, order: prayers.count)
        prayers.append(prayer)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: prayers.count - 1, section: 0)], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
        PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editAction(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
        navigationItem.rightBarButtonItem = nil
        editButton.title = self.tableView.isEditing ? "Done" : "Edit"
        navigationItem.rightBarButtonItem = editButton
    }
    
    func updatePrayerOrder(){
        for (index, prayer) in prayers.enumerated() {
            prayer.order = index
            PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
        }
    }
    
    func pushToPrayerDetailSettings(){
        self.performSegue(withIdentifier: "prayerSettingsDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PrayerModelSettingsController, let selectedPrayer = self.selectedPrayer {
            destVC.prayer = selectedPrayer
        }
    }
    
}

extension PrayerSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrayerSettingsTableViewCell.reuseIdentifier, for: indexPath) as! PrayerSettingsTableViewCell
        
        cell.setUp(title: prayers[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedPrayer = prayers[indexPath.row]
        pushToPrayerDetailSettings()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let prayer = prayers[indexPath.row]
            PrayerInterface.deletePrayer(prayerModel: prayer, inContext: CoreDataManager.mainContext)
            self.prayers.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.endUpdates()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Prayers"
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.prayers[sourceIndexPath.row]
        self.prayers.remove(at: sourceIndexPath.row)
        self.prayers.insert(movedObject, at: destinationIndexPath.row)
        updatePrayerOrder()
    }
}
