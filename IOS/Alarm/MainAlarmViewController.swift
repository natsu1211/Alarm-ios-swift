//
//  MainAlarmViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import MediaPlayer

class MainAlarmViewController: UITableViewController{
    
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    var scheduler: AlarmSchedulerDelegate = Scheduler()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelectionDuringEditing = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.reloadData()
        //dynamically append the edit button
        if Alarms.sharedInstance.count != 0
        {
            self.navigationItem.leftBarButtonItem = editButtonItem
            //self.navigationItem.leftBarButtonItem?.tintColor = UIColor.redColor()
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil
        }
        //unschedule all the notifications, faster than calling the cancelAllNotifications func
        UIApplication.shared.scheduledLocalNotifications = nil
        
        let cells = tableView.visibleCells
        if !cells.isEmpty
        {
            assert( cells.count==Alarms.sharedInstance.count, "alarms not been updated correctly")
            var count = cells.count
            while count>0
            {
                if Alarms.sharedInstance[count-1].enabled
                {
                    (cells[count-1].accessoryView as! UISwitch).setOn(true, animated: false)
                    cells[count-1].backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
                else
                {
                    (cells[count-1].accessoryView as! UISwitch).setOn(false, animated: false)
                    cells[count-1].backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                }
                
                count -= 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing,  animated: animated)
        let cells = tableView.visibleCells() as? [UITableViewCell]
        if cells != nil{

            for cell in cells!
            {
                cell.userInteractionEnabled = editing ? true : false
            }
        }
    }
    */

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if Alarms.sharedInstance.count == 0
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        else
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        return Alarms.sharedInstance.count

        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isEditing
        {
            Global.indexOfCell = indexPath.row
            self.tableView.tag = indexPath.row
            performSegue(withIdentifier: "editSegue", sender: self)
        }
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? UITableViewCell
        
        if cell == nil{
            cell = UITableViewCell(
                style: UITableViewCellStyle.subtitle, reuseIdentifier: "AlarmCell")
        }
       
        
        
        cell!.tag = indexPath.row
        let ala = Alarms.sharedInstance[indexPath.row] as Alarm
        cell!.textLabel?.text = ala.timeStr
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 22.0)
        cell!.detailTextLabel?.text = ala.label

  

        // Configure the cell...
        
        let sw = UISwitch(frame: CGRect())
        //sw.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        //tag is used to indicate which row had been touched
        sw.tag = indexPath.row
        cell!.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        sw.addTarget(self, action: #selector(MainAlarmViewController.switchTapped(_:)), for: UIControlEvents.touchUpInside)
        if ala.enabled
        {
            sw.setOn(true, animated: false)
        }
        cell!.accessoryView = sw
        
        
        //delete empty seperator line
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        return cell!
    }
    /*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.
    }
    */
    
    
    
    @IBAction func switchTapped(_ sender: UISwitch)
    {
        Global.indexOfCell = sender.tag
        Alarms.sharedInstance.setEnabled(sender.isOn, AtIndex: sender.tag)
        Alarms.sharedInstance.PersistAlarm(sender.tag)
        if sender.isOn
        {
            print("switch on")
            sender.superview?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            scheduler.setNotificationWithDate(Alarms.sharedInstance[sender.tag].date, onWeekdaysForNotify: Alarms.sharedInstance[sender.tag].repeatWeekdays, snooze: Alarms.sharedInstance[sender.tag].snoozeEnabled, soundName: Alarms.sharedInstance[sender.tag].mediaLabel, index: sender.tag)
        }
        else
        {
            print("switch off")
            sender.superview?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            scheduler.reSchedule()
            
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alarms.sharedInstance.removeAtIndex(indexPath.row)
            Alarms.sharedInstance.deleteAlarm(indexPath.row)
            let cells = tableView.visibleCells 
            for cell in cells
            {
                let sw = cell.accessoryView as! UISwitch
                if sw.tag > indexPath.row
                {
                    sw.tag -= 1
                }
            }
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dist = segue.destination as! UINavigationController
        let addEditController = dist.topViewController as! AlarmAddEditViewController
        if segue.identifier == "addSegue"
        {
            addEditController.navigationItem.title = "Add Alarm"
            Global.isEditMode = false
            Global.label = "Alarm"
            Global.mediaLabel = "bell"
            Global.weekdays.removeAll(keepingCapacity: true)
            Global.snoozeEnabled = false
        }
        else if segue.identifier == "editSegue"
        {
            addEditController.navigationItem.title = "Edit Alarm"
            Global.isEditMode = true
            Global.weekdays = Alarms.sharedInstance[Global.indexOfCell].repeatWeekdays
            Global.label = Alarms.sharedInstance[Global.indexOfCell].label
            Global.mediaLabel = Alarms.sharedInstance[Global.indexOfCell].mediaLabel
            Global.snoozeEnabled = Alarms.sharedInstance[Global.indexOfCell].snoozeEnabled
        }
        
        
    }
    
    @IBAction func unwindToMainAlarmView(_ segue: UIStoryboardSegue) {
        isEditing = false
        Global.weekdays.removeAll(keepingCapacity: true)
        
    }

}
