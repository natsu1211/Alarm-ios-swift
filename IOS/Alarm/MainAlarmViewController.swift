import UIKit

class MainAlarmViewController: UITableViewController{
   
    private let alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    private let scheduler: AlarmSchedulerDelegate = AlarmScheduler()
    private var selectedIndexPath: IndexPath?
    private var alarms: Alarms = Store.shared.load() ?? Alarms()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduler.checkNotification()
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        //dynamically append the edit button
        if alarms.count != 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        else {
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
        }
        else {
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
        var cell = tableView.dequeueReusableCell(withIdentifier: Identifier.alarmCellIdentifier) ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: Identifier.alarmCellIdentifier)

        //cell text
        cell.selectionStyle = .none
        let alarm = alarms[indexPath.row]
        let amAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 20.0)]
        let str = NSMutableAttributedString(string: alarm.formattedTime, attributes: amAttr)
        let timeAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 45.0)]
        str.addAttributes(timeAttr, range: NSMakeRange(0, str.length-2))
        cell.textLabel?.attributedText = str
        cell.detailTextLabel?.text = alarm.label
        
        //append switch button
        let sw = UISwitch(frame: CGRect())
        sw.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
        sw.addTarget(self, action: #selector(MainAlarmViewController.switchTapped(_:)), for: UIControlEvents.valueChanged)
        if alarm.enabled {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.alpha = 1.0
            cell.detailTextLabel?.alpha = 1.0
            sw.setOn(true, animated: false)
        } else {
            cell.backgroundColor = UIColor.groupTableViewBackground
            cell.textLabel?.alpha = 0.5
            cell.detailTextLabel?.alpha = 0.5
        }
        cell.accessoryView = sw
        
        //delete empty seperator line
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        guard let indexPath = tableView.indexPath(forSubView: sender) else {return}
        selectedIndexPath = indexPath
        let alarm = alarms[indexPath.row]
        alarm.enabled = sender.isOn
        if sender.isOn {
            print("switch on")
            //scheduler.setNotificationBy(alarm)
            
        }
        else {
            print("switch off")
            //scheduler.reSchedule()
        }
        tableView.reloadData()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            alarms.remove(at: index)

            if alarms.count == 0 {
                self.navigationItem.leftBarButtonItem = nil
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            scheduler.reSchedule()
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
        }
        else if segue.identifier == Identifier.editSegueIdentifier {
            addEditController.navigationItem.title = "Edit Alarm"
            guard let indexPath = selectedIndexPath else {return}
            addEditController.currentAlarm = alarms[indexPath.row]
        }
    }
    
    @IBAction func unwindFromAddEditAlarmView(_ segue: UIStoryboardSegue) {
        isEditing = false
        self.tableView.reloadData()
    }
}
