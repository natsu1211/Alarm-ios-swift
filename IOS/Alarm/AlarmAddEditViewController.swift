//
//  AlarmAddViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-3-2.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer



class AlarmAddEditViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource{

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var scheduler: AlarmSchedulerDelegate = Scheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
        //mediaPicker.delegate = self
       // mediaPicker.prompt = "Select any song!"
       // mediaPicker.allowsPickingMultipleItems = false
        //presentViewController(mediaPicker, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveEditAlarm(_ sender: AnyObject) {
        let date = datePicker.date
        //let timeStr = NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = dateFormatter.string(from: date)
        if Global.isEditMode
        {
            Alarms.sharedInstance.setDate(date, AtIndex: Global.indexOfCell)
            Alarms.sharedInstance.setTimeStr(timeStr, AtIndex: Global.indexOfCell)
            Alarms.sharedInstance.setWeekdays(Global.weekdays, AtIndex: Global.indexOfCell)
            Alarms.sharedInstance.setSnooze(Global.snoozeEnabled, AtIndex: Global.indexOfCell)
            Alarms.sharedInstance.setLabel(Global.label, AtIndex: Global.indexOfCell)
            Alarms.sharedInstance.setMediaLabel(Global.mediaLabel, AtIndex: Global.indexOfCell)
            Alarms.sharedInstance.PersistAlarm(Global.indexOfCell)
            //scheduler.reSchedule()
        }
        else
        {
            Alarms.sharedInstance.append( Alarm(label: Global.label, timeStr: timeStr, date: date,  enabled: false, snoozeEnabled: Global.snoozeEnabled, UUID: UUID().uuidString, mediaID: "", mediaLabel: "bell", repeatWeekdays: Global.weekdays))
        }
        
        //navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
        scheduler.reSchedule()
        self.performSegue(withIdentifier: "saveEditAlarm", sender: self)
    }
    
    
    let settingIdentifier = "setting"
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        if Global.isEditMode
        {
            return 2
        }
        else
        {
            return 1

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 4
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(
            withIdentifier: settingIdentifier)
        if cell == nil {
            cell = UITableViewCell(
                style: UITableViewCellStyle.value1, reuseIdentifier: settingIdentifier)
        }
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
                
                cell!.textLabel!.text = "Repeat"
                cell!.detailTextLabel!.text = WeekdaysViewController.repeatText()
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 1
            {
                cell!.textLabel!.text = "Label"
                
                cell!.detailTextLabel!.text = Global.label
                
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 2
            {
                cell!.textLabel!.text = "Sound"
                cell!.detailTextLabel!.text = MediaTableViewController.mediaText()
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 3
            {
               
                cell!.textLabel!.text = "Snooze"
                let sw = UISwitch(frame: CGRect())
                sw.addTarget(self, action: #selector(AlarmAddEditViewController.snoozeSwitchTapped(_:)), for: UIControlEvents.touchUpInside)
                
                if Global.snoozeEnabled
                {
                   sw.setOn(true, animated: false)
                }
                
                cell!.accessoryView = sw
            }
        }
        else if indexPath.section == 1{
            cell = UITableViewCell(
                style: UITableViewCellStyle.default, reuseIdentifier: settingIdentifier)
            cell!.textLabel!.text = "Delete Alarm"
            cell!.textLabel!.textAlignment = .center
            cell!.textLabel!.textColor = UIColor.red
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        /*
        let title = NSLocalizedString("Choose a Alarm Interval", comment: "")
        //let message = NSLocalizedString("Choose Interval", comment: "")
        let onceActionTitle = NSLocalizedString(intervalArray[0], comment: "")
        let everydayActionTitle = NSLocalizedString(intervalArray[1], comment: "")
        let weekdayActionTitle = NSLocalizedString(intervalArray[2], comment: "")
        let weekendActionTitle = NSLocalizedString(intervalArray[3], comment: "")
        let cancelActionTitle = NSLocalizedString(intervalArray[4], comment: "")
        
        let storageController = UIAlertController(title: title, message: nil, preferredStyle: ./*ActionSheet*/Alert)
            
        let onceOption = UIAlertAction(title: onceActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .Once
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(onceOption)
            
        let everydayOption = UIAlertAction(title: everydayActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .EveryDay
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(everydayOption)
            
        let weekdayOption = UIAlertAction(title: weekdayActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .WeekDay
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(weekdayOption)
            
        let weekendOption = UIAlertAction(title: weekendActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .WeekEnd
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(weekendOption)
            
        let cancelOption = UIAlertAction(title: cancelActionTitle, style: .Cancel) {(action:UIAlertAction!)->Void in }
        storageController.addAction(cancelOption)
        
            
        presentViewController(storageController, animated: true, completion: nil)
        */
        if indexPath.section == 0
        {
            switch indexPath.row{
            case 0:
                performSegue(withIdentifier: "weekdaysSegue", sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 1:
                performSegue(withIdentifier: "labelEditSegue", sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 2:
                performSegue(withIdentifier: "musicSegue", sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            default:
                break
            }
        }
        else if indexPath.section == 1
        {
            Alarms.sharedInstance.removeAtIndex(Global.indexOfCell)
            Alarms.sharedInstance.deleteAlarm(Global.indexOfCell)
            
            performSegue(withIdentifier: "saveEditAlarm", sender: self)
        
            
        }
            
    }
   
    @IBAction func snoozeSwitchTapped (_ sender: UISwitch)
    {
       
        if sender.isOn{
            Global.snoozeEnabled = true
        }
        else
        {
            
            Global.snoozeEnabled = false
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveEditAlarm"
        {
            let alaVC = segue.destination as! MainAlarmViewController
            let cells = alaVC.tableView.visibleCells 
            for cell in cells
            {
                let sw = cell.accessoryView as! UISwitch
                if sw.tag > Global.indexOfCell
                {
                    sw.tag -= 1
                }
            }
        }
        
    }
    
    
    

}
