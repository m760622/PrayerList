//
//  PrayerSettingsViewController.swift
//  PrayerList
//
//  Created by Devin  on 16/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications

enum PrayerSettingsRow {
    case name
    case delete
    case time
    case remind
    case reminderDays
    case alert
    
    static func sections(_ prayer: PrayerModel) ->  [[PrayerSettingsRow]] {
        if prayer.shouldRemind {
            return [[.name], [.time, .remind, .reminderDays, .alert], [.delete]]
        } else {
            return [[.name], [.time, .remind], [.delete]]
        }
    }
}

class PrayerSettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedPrayer: PrayerModel!
    
    weak var delegate: PrayerSettingsDelegate?
    
    var pickerIndexPath: IndexPath?
    var pickerVisible: Bool { return pickerIndexPath != nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: SwitchTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: DateSelectionCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DateSelectionCell.reuseIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        
        updateNotifications()
        
        PrayerInterface.savePrayer(prayer: selectedPrayer, inContext: CoreDataManager.mainContext)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func updateNotifications(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: selectedPrayer.notificationIdentifiers)
        
        guard selectedPrayer.shouldRemind, let time = selectedPrayer.time else { return }
        
        if let correctedDate = Calendar.current.date(byAdding: .minute, value: -(selectedPrayer.remindTime.rawValue), to: time), let minute = DateHelper.getMinutesFromDate(correctedDate), let hour = DateHelper.getHoursFromDate(correctedDate) {
            
            for day in selectedPrayer.remindOnDays {
                let date = createDate(weekday: day.rawValue, hour: hour, minute: minute)
                var message = "It's time to do your \(selectedPrayer.name!) prayer"
                if(selectedPrayer.remindTime != .atTime) {
                    message = "\(selectedPrayer.remindTime.rawValue) minutes until your \(selectedPrayer.name!) prayer"
                }
                
                scheduleNotification(at: date, body: message, titles: "Prayer Reminder")
            }
        }
    }
    
    func deletePrayer(){
        let alert = UIAlertController(title: "Delete Prayer", message: "Are you sure you want to delete this prayer?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
            self.delete()
        }))
        
        alert.view.tintColor = Theme.Color.PrimaryTint
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete(){
        PrayerInterface.deletePrayer(prayerModel: selectedPrayer, inContext: CoreDataManager.mainContext)
        self.dismiss(animated: true) {
            self.delegate?.prayerDeleted(prayer: self.selectedPrayer)
        }
    }
    

    @IBAction func doneAction(_ sender: Any) {
        delegate?.prayerUpdated(prayer: selectedPrayer)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DaySelectionViewController {
            dest.delegate = self
            dest.selectedDays = selectedPrayer.remindOnDays
        } else if let dest = segue.destination as? ReminderTimeSelectionViewController {
            dest.delegate = self
            dest.selectedTime = selectedPrayer.remindTime
        }
    }

}

extension PrayerSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PrayerSettingsRow.sections(selectedPrayer).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = PrayerSettingsRow.sections(selectedPrayer)[section].count
        
        if pickerVisible && section == pickerIndexPath!.section {
            count += 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pickerVisible && pickerIndexPath! == indexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectionCell.reuseIdentifier, for: indexPath) as! DateSelectionCell
            cell.delegate = self
            
            if let date = selectedPrayer.time {
                cell.picker.date = date
            }
            
            return cell
        } else {
            let item = calculateFieldForIndexPath(indexPath: indexPath)
            
            switch item {
            case .name:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.delegate = self
                
                cell.setUp(title: "Name", detail: self.selectedPrayer.name, placeholder: "Name", isEditable: true, indexPath: indexPath)
                cell.accessoryType = .none
                return cell
            case .delete:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.delegate = self
                cell.setUp(title: "Delete", detail: nil, isEditable: false, indexPath: indexPath, titleColor: Theme.Color.Error)
                return cell
            case .time:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                
                var dateString = "Set time"
                if let date = selectedPrayer.time {
                    dateString = DateHelper.getStringFromDate(date: date, format: "h:mma")
                }
                
                cell.setUp(title: "Time", detail: nil, placeholder: dateString, isEditable: false, indexPath: indexPath)
                return cell
            case .reminderDays:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                var placeholder = "Everyday"
                let count = selectedPrayer.remindOnDays.count
                if count < 7 {
                    placeholder = "\(selectedPrayer.remindOnDays.count)\(count == 1 ? "s" : "") days"
                }
                cell.setUp(title: "On Days", detail: nil, placeholder: placeholder, isEditable: false, indexPath: indexPath)
                cell.accessoryType = .disclosureIndicator
                return cell
            case .remind:
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
                cell.selectionStyle = .none
                cell.setUp(title: "Remind", switchState: selectedPrayer.shouldRemind, indexPath: indexPath)
                cell.delegate = self
                return cell
            case .alert:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.setUp(title: "Alert", detail: nil, placeholder: selectedPrayer.remindTime.title, isEditable: false, indexPath: indexPath)
                cell.accessoryType = .disclosureIndicator
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
        let item = calculateFieldForIndexPath(indexPath: indexPath)
        switch item {
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        case .delete:
            deletePrayer()
        case .time:
            togglePicker(indexPath: indexPath)
        case .reminderDays:
            self.performSegue(withIdentifier: "showDaySelection", sender: self)
        case .remind:
            print("push away!!")
        case .alert:
             self.performSegue(withIdentifier: "showAlertSelectionSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Detials"
        } else if section == 1 {
            return "Time"
        }
        
        return nil
    }
    
    func calculateFieldForIndexPath(indexPath: IndexPath) -> PrayerSettingsRow {
        if pickerVisible && pickerIndexPath!.section == indexPath.section {
            if pickerIndexPath!.row == indexPath.row {
                return PrayerSettingsRow.sections(selectedPrayer)[indexPath.section][indexPath.row - 1]
            } else if pickerIndexPath!.row > indexPath.row {
                return PrayerSettingsRow.sections(selectedPrayer)[indexPath.section][indexPath.row]
            } else {
                return  PrayerSettingsRow.sections(selectedPrayer)[indexPath.section][indexPath.row - 1]
            }
        } else {
            return PrayerSettingsRow.sections(selectedPrayer)[indexPath.section][indexPath.row]
        }
    }
    
    func togglePicker(indexPath: IndexPath){
        if !pickerShouldAppearForRowSelectionAtIndexPath(indexPath: indexPath) {
            dismissPickerRow()
            return
        }
        
        tableView.beginUpdates()
        if pickerVisible {
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            let oldDatePickerIndexPath = pickerIndexPath!
            
            if pickerIsRightBelowMe(indexPath: indexPath) {
                self.pickerIndexPath = nil
            } else {
                let newRow = oldDatePickerIndexPath.row < indexPath.row ? indexPath.row : indexPath.row + 1
                self.pickerIndexPath = IndexPath(row: newRow, section: indexPath.section)
                tableView.insertRows(at: [self.pickerIndexPath!], with: .fade)
            }
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        } else {
            self.pickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [self.pickerIndexPath!], with: .fade)
        }
        tableView.endUpdates()
    }
    
    func dismissPickerRow() {
        if !pickerVisible { return }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
        tableView.reloadRows(at: [IndexPath(row: 0, section :1)], with: .automatic)
        pickerIndexPath = nil
        tableView.endUpdates()
    }
    
    func pickerShouldAppearForRowSelectionAtIndexPath(indexPath: IndexPath) -> Bool {
        if indexPath.row < PrayerSettingsRow.sections(selectedPrayer)[indexPath.section].count {
            let field = calculateFieldForIndexPath(indexPath: indexPath)
            if field == .time {
                return true
            }
            return false
        }
        return false
    }
    
    func pickerIsRightAboveMe(indexPath: IndexPath) -> Bool {
        if pickerVisible && pickerIndexPath!.section == indexPath.section {
            if indexPath.section != pickerIndexPath!.section { return false }
            else { return indexPath.row == pickerIndexPath!.row + 1 }
        } else { return false }
    }
    
    func pickerIsRightBelowMe(indexPath: IndexPath) -> Bool {
        if pickerVisible && pickerIndexPath!.section == indexPath.section {
            if indexPath.section != pickerIndexPath!.section { return false }
            else { return indexPath.row == pickerIndexPath!.row - 1 }
        } else { return false }
    }
}

extension PrayerSettingsViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        guard let text = text else { return }
        let item = PrayerSettingsRow.sections(selectedPrayer)[indexPath.section][indexPath.row]
        if item == .name {
             selectedPrayer.name = text
        }
    }
}

extension PrayerSettingsViewController: SwitchCellDelegate {
    func switchToggled(indexPath: IndexPath) {
        selectedPrayer.shouldRemind = !selectedPrayer.shouldRemind
        
        if selectedPrayer.shouldRemind {
            selectedPrayer.remindOnDays = DayAlert.allCases
        } else {
            selectedPrayer.remindOnDays.removeAll()
        }
        
        let index = pickerVisible ? 3 : 2
        tableView.beginUpdates()
        if selectedPrayer.shouldRemind {
            tableView.insertRows(at: [IndexPath(row: index, section: 1), IndexPath(row: index + 1, section: 1)], with: .automatic)
        } else {
            tableView.deleteRows(at: [IndexPath(row: index, section: 1), IndexPath(row: index + 1, section: 1)], with: .automatic)
        }
        tableView.endUpdates()
    }
}

extension PrayerSettingsViewController: DatePickerDelegate {
    func selectedDate(date: Date) {
        selectedPrayer.time = date
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        tableView.endUpdates()
    }
}

extension PrayerSettingsViewController: DaySelectionDelegate {
    func updated(selectedDays: [DayAlert]) {
        selectedPrayer.remindOnDays = selectedDays
    }
}

extension PrayerSettingsViewController: ReminderTimeDelegate {
    func reminderTimeUpdates(timeAlert: TimeAlert) {
        selectedPrayer.remindTime = timeAlert
    }
}

extension PrayerSettingsViewController: UNUserNotificationCenterDelegate {
    func createDate(weekday: Int, hour: Int, minute: Int )-> Date{
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.weekday = weekday // sunday = 1 ... saturday = 7
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return Calendar.current.date(from: components)!
    }
    
    func scheduleNotification(at date: Date, body: String, titles: String) {
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = selectedPrayer.uuid!
        
        selectedPrayer.notificationIdentifiers.append("\(selectedPrayer.uuid!)\(date)")

        let request = UNNotificationRequest(identifier: "\(selectedPrayer.uuid!)\(date)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }

    }
}

