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
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveEditAlarm(sender: AnyObject) {
        let date = datePicker.date
        let timeStr = NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
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
            Alarms.sharedInstance.append( Alarm(label: Global.label, timeStr: timeStr, date: date,  enabled: false, snoozeEnabled: Global.snoozeEnabled, UUID: NSUUID().UUIDString, mediaID: "", mediaLabel: "bell", repeatWeekdays: Global.weekdays))
        }
        
        //navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
        scheduler.reSchedule()
        self.performSegueWithIdentifier("saveEditAlarm", sender: self)
    }
    
    
    let settingIdentifier = "setting"
    
 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 4
        }
        else
        {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(
            settingIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(
                style: UITableViewCellStyle.Value1, reuseIdentifier: settingIdentifier)
        }
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
                
                cell!.textLabel!.text = "Repeat"
                cell!.detailTextLabel!.text = WeekdaysViewController.repeatText()
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else if indexPath.row == 1
            {
                cell!.textLabel!.text = "Label"
                
                cell!.detailTextLabel!.text = Global.label
                
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else if indexPath.row == 2
            {
                cell!.textLabel!.text = "Sound"
                cell!.detailTextLabel!.text = MediaTableViewController.mediaText()
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else if indexPath.row == 3
            {
               
                cell!.textLabel!.text = "Snooze"
                let sw = UISwitch(frame: CGRect())
                sw.addTarget(self, action: "snoozeSwitchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                
                if Global.snoozeEnabled
                {
                   sw.setOn(true, animated: false)
                }
                
                cell!.accessoryView = sw
            }
        }
        else if indexPath.section == 1{
            cell = UITableViewCell(
                style: UITableViewCellStyle.Default, reuseIdentifier: settingIdentifier)
            cell!.textLabel!.text = "Delete Alarm"
            cell!.textLabel!.textAlignment = .Center
            cell!.textLabel!.textColor = UIColor.redColor()
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
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
                performSegueWithIdentifier("weekdaysSegue", sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 1:
                performSegueWithIdentifier("labelEditSegue", sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 2:
                performSegueWithIdentifier("musicSegue", sender: self)
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
            
            performSegueWithIdentifier("saveEditAlarm", sender: self)
        
            
        }
            
    }
    
   /* override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowValue = alarms[indexPath.row].timeStr
        let message = "You selected \(rowValue)"
        let controller = UIAlertController(title: "Row Selected",
            message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Yes I Did",
            style: .Default, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }*/
    
    /*
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return "Interval"
    }
*/
   
    @IBAction func snoozeSwitchTapped (sender: UISwitch)
    {
       
        if sender.on{
            Global.snoozeEnabled = true
        }
        else
        {
            
            Global.snoozeEnabled = false
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveEditAlarm"
        {
            var alaVC = segue.destinationViewController as! MainAlarmViewController
            var cells = alaVC.tableView.visibleCells() as! [UITableViewCell]
            for cell in cells
            {
                var sw = cell.accessoryView as! UISwitch
                if sw.tag > Global.indexOfCell
                {
                    sw.tag -= 1
                }
            }
        }
        
    }
    
    
    

}
