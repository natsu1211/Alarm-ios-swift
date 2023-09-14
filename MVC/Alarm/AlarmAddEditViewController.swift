import UIKit
import Foundation

class AlarmAddEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    var alarms: Alarms?
    var currentAlarm: Alarm?
    var isEditMode = false

    
    private var snoozeEnabled = false
    private var label = ""
    private var repeatWeekdays: [Int] = []
    private var mediaLabel = ""
    private var mediaID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let alarm = currentAlarm {
            snoozeEnabled = alarm.snoozeEnabled
            label = alarm.label
            repeatWeekdays = alarm.repeatWeekdays
            mediaLabel = alarm.mediaLabel
            mediaID = alarm.mediaID
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveEditAlarm(_ sender: AnyObject) {
        let date = NotificationScheduler.correctSecondComponent(date: datePicker.date)
        
        if let alarm = currentAlarm {
            alarm.date = date
            alarm.enabled = true
            alarm.snoozeEnabled = snoozeEnabled
            alarm.label = label
            alarm.mediaID = mediaID
            alarm.mediaLabel = mediaLabel
            alarm.repeatWeekdays = repeatWeekdays
            if isEditMode {
                alarms?.update(alarm)
            }
            else {
                alarms?.add(alarm)
            }
        }
        self.performSegue(withIdentifier: Identifier.saveSegueIdentifier, sender: self)
    }
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        if isEditMode {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else {
            return 1
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: Identifier.settingIdentifier) ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Identifier.settingIdentifier)
        var cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Identifier.settingIdentifier)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Repeat"
                if let alarm = currentAlarm {
                    cell.detailTextLabel?.text = WeekdaysViewController.repeatText(weekdays: repeatWeekdays)
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Label"
                cell.detailTextLabel?.text = label
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 2 {
                cell.textLabel?.text = "Sound"
                cell.detailTextLabel?.text = mediaLabel
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 3 {
                cell.textLabel?.text = "Snooze"
                let sw = UISwitch(frame: CGRect())
                sw.addTarget(self, action: #selector(AlarmAddEditViewController.snoozeSwitchTapped(_:)), for: UIControlEvents.touchUpInside)
                
                sw.setOn(snoozeEnabled == true, animated: false)
                cell.accessoryView = sw
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            cell = UITableViewCell(
                style: UITableViewCellStyle.default, reuseIdentifier: Identifier.settingIdentifier)
            cell.textLabel?.text = "Delete Alarm"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.red
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
                performSegue(withIdentifier: Identifier.weekdaysSegueIdentifier, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 1:
                performSegue(withIdentifier: Identifier.labelSegueIdentifier, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 2:
                performSegue(withIdentifier: Identifier.soundSegueIdentifier, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            default:
                break
            }
        }
        else if indexPath.section == 1 {
            //delete alarm
            guard let alarm = currentAlarm else {fatalError()}
            alarms?.remove(alarm)
            performSegue(withIdentifier: Identifier.saveSegueIdentifier, sender: self)
        }
            
    }
   
    @IBAction func snoozeSwitchTapped (_ sender: UISwitch) {
        snoozeEnabled = sender.isOn
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Identifier.soundSegueIdentifier {
            // TODO
            guard let dist = segue.destination as? MediaViewController else {fatalError()}
            dist.mediaID = mediaID
            dist.mediaLabel = mediaLabel
            
        }
        else if segue.identifier == Identifier.labelSegueIdentifier {
            guard let dist = segue.destination as? LabelEditViewController else {fatalError()}
            dist.label = label
        }
        else if segue.identifier == Identifier.weekdaysSegueIdentifier {
            guard let dist = segue.destination as? WeekdaysViewController else {fatalError()}
            dist.weekdays = repeatWeekdays
        }
    }
    
    @IBAction func unwindFromWeekdaysView(_ segue: UIStoryboardSegue) {
        guard let src = segue.source as? WeekdaysViewController else {fatalError()}
        repeatWeekdays = src.weekdays
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    @IBAction func unwindFromLabelEditView(_ segue: UIStoryboardSegue) {
        guard let src = segue.source as? LabelEditViewController else {fatalError()}
        label = src.label
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }

    @IBAction func unwindFromMediaView(_ segue: UIStoryboardSegue) {
        guard let src = segue.source as? MediaViewController else {fatalError()}
        mediaLabel = src.mediaLabel ?? ""
        mediaID = src.mediaID ?? ""
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
}
