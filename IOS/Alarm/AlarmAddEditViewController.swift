import UIKit
import Foundation

class AlarmAddEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    private let alarmScheduler: AlarmSchedulerDelegate = AlarmScheduler()
    private var snoozeEnabled = false
    var alarms: Alarms?
    var currentAlarm: Alarm?
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveEditAlarm(_ sender: AnyObject) {
        let date = AlarmScheduler.correctSecondComponent(date: datePicker.date)

        if !isEditMode {
            var newAlarm = Alarm()
            alarms?.add(newAlarm)
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
        var cell = tableView.dequeueReusableCell(withIdentifier: Identifier.settingIdentifier) ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Identifier.settingIdentifier)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Repeat"
                if let alarm = currentAlarm {
                    cell.detailTextLabel?.text = WeekdaysViewController.repeatText(weekdays: alarm.repeatWeekdays)
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Label"
                cell.detailTextLabel?.text = currentAlarm?.label
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 2 {
                cell.textLabel?.text = "Sound"
                cell.detailTextLabel?.text = currentAlarm?.mediaLabel
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 3 {
               
                cell.textLabel?.text = "Snooze"
                let sw = UISwitch(frame: CGRect())
                sw.addTarget(self, action: #selector(AlarmAddEditViewController.snoozeSwitchTapped(_:)), for: UIControlEvents.touchUpInside)
                
                if snoozeEnabled {
                   sw.setOn(true, animated: false)
                }
                
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
        if segue.identifier == Identifier.saveSegueIdentifier {
            guard let dist = segue.destination as? MainAlarmViewController else {fatalError()}
            alarmScheduler.reSchedule()
        }
        else if segue.identifier == Identifier.soundSegueIdentifier {
            // TODO
            guard let dist = segue.destination as? MediaViewController else {fatalError()}
            if let alarm = currentAlarm {
                dist.mediaID = alarm.mediaID
                dist.mediaLabel = alarm.mediaLabel
            }
        }
        else if segue.identifier == Identifier.labelSegueIdentifier {
            guard let dist = segue.destination as? LabelEditViewController else {fatalError()}
            if let alarm = currentAlarm {
                dist.label = alarm.label
            }
        }
        else if segue.identifier == Identifier.weekdaysSegueIdentifier {
            guard let dist = segue.destination as? WeekdaysViewController else {fatalError()}
            dist.weekdays = currentAlarm?.repeatWeekdays ?? [Int]()
        }
    }
    
    @IBAction func unwindFromLabelEditView(_ segue: UIStoryboardSegue) {
        guard let src = segue.source as? LabelEditViewController else {fatalError()}
        currentAlarm?.label = src.label
    }
    
    @IBAction func unwindFromWeekdaysView(_ segue: UIStoryboardSegue) {
        guard let src = segue.source as? WeekdaysViewController else {fatalError()}
        currentAlarm?.repeatWeekdays = src.weekdays
    }
    
    @IBAction func unwindFromMediaView(_ segue: UIStoryboardSegue) {
        guard let src = segue.source as? MediaViewController else {fatalError()}
        currentAlarm?.mediaLabel = src.mediaLabel ?? ""
        currentAlarm?.mediaID = src.mediaID ?? ""
    }
}
