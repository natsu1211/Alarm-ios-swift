import UIKit

class MainAlarmViewController: UITableViewController{
   
    private let alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    private let scheduler: NotificationSchedulerDelegate = NotificationScheduler()
    private let alarms: Alarms = Store.shared.alarms
    
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelectionDuringEditing = true
        //add notification handler
        NotificationCenter.default.addObserver(self, selector: #selector(handleChangeNotification(_:)), name: Store.changedNotification, object: nil)
        //dynamically append the edit button
        if alarms.count != 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if alarms.count == 0 {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        return alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if isEditing {
            performSegue(withIdentifier: Identifier.editSegueIdentifier, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.alarmCellIdentifier) ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: Identifier.alarmCellIdentifier)
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: Identifier.alarmCellIdentifier)

        //cell text
        cell.selectionStyle = .none
        let alarm = alarms[indexPath.row]
        let amAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 20.0)]
        let str = NSMutableAttributedString(string: alarm.formattedTime, attributes: amAttr)
        let timeAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 45.0)]
        str.addAttributes(timeAttr, range: NSMakeRange(0, str.length-2))
        cell.textLabel?.attributedText = str
        cell.detailTextLabel?.text = alarm.label
        
        let sw = UISwitch(frame: CGRect())
        sw.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
        sw.addTarget(self, action: #selector(MainAlarmViewController.switchTapped(_:)), for: UIControlEvents.valueChanged)
        cell.accessoryView = sw
        
        if alarm.enabled {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.alpha = 1.0
            cell.detailTextLabel?.alpha = 1.0
            sw.setOn(true, animated: false)
        } else {
            cell.backgroundColor = UIColor.groupTableViewBackground
            cell.textLabel?.alpha = 0.5
            cell.detailTextLabel?.alpha = 0.5
            sw.setOn(false, animated: false)
        }
        
        //delete empty seperator line
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        guard let indexPath = tableView.indexPath(forSubView: sender) else {return}
        selectedIndexPath = indexPath
        let alarm = alarms[indexPath.row]
        alarm.enabled = sender.isOn
        alarms.update(alarm)
    }
    
    @objc func handleChangeNotification(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        // Handle changes to contents
        if let changeReason = userInfo[Alarm.changeReasonKey] as? String {
            let newValue = userInfo[Alarm.newValueKey]
            let oldValue = userInfo[Alarm.oldValueKey]
            switch (changeReason, newValue, oldValue) {
            case let (Alarm.removed, (uuid as String)?, (oldValue as Int)?):
                tableView.deleteRows(at: [IndexPath(row: oldValue, section: 0)], with: .fade)
                if alarms.count == 0 {
                    self.navigationItem.leftBarButtonItem = nil
                }
                scheduler.cancelNotification(ByUUIDStr: uuid)
            case let (Alarm.added, (index as Int)?, _):
                tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.navigationItem.leftBarButtonItem = editButtonItem
                let alarm = alarms[index]
                scheduler.setNotification(date: alarm.date, ringtoneName: alarm.mediaLabel, repeatWeekdays: alarm.repeatWeekdays, snoozeEnabled: alarm.snoozeEnabled, onSnooze: false, uuid: alarm.uuid.uuidString)
            case let (Alarm.updated, (index as Int)?, _):
                let alarm = alarms[index]
                let uuid = alarm.uuid.uuidString
                if alarm.enabled {
                    scheduler.updateNotification(ByUUIDStr: uuid, date: alarm.date, ringtoneName: alarm.mediaLabel, repeatWeekdays: alarm.repeatWeekdays, snoonzeEnabled: alarm.snoozeEnabled)
                } else {
                    scheduler.cancelNotification(ByUUIDStr: uuid)
                }
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            default: tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            alarms.remove(at: index)
        }   
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard
            let dist = segue.destination as? UINavigationController,
            let addEditController = dist.topViewController as? AlarmAddEditViewController
        else {return}
        if segue.identifier == Identifier.addSegueIdentifier {
            addEditController.navigationItem.title = "Add Alarm"
            addEditController.isEditMode = false
            addEditController.alarms = alarms
            addEditController.currentAlarm = Alarm()
        }
        else if segue.identifier == Identifier.editSegueIdentifier {
            guard let indexPath = selectedIndexPath else {return}
            addEditController.navigationItem.title = "Edit Alarm"
            addEditController.isEditMode = true
            addEditController.alarms = alarms
            addEditController.currentAlarm = alarms[indexPath.row]
        }
    }
    
    @IBAction func unwindFromAddEditAlarmView(_ segue: UIStoryboardSegue) {
        isEditing = false
    }
}
