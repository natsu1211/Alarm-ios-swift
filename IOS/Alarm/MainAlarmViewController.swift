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
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.reloadData()
        //dynamically append the edit button
        if Alarms.sharedInstance.count != 0
        {
            self.navigationItem.leftBarButtonItem = editButtonItem()
            //self.navigationItem.leftBarButtonItem?.tintColor = UIColor.redColor()
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil
        }
        //unschedule all the notifications, faster than calling the cancelAllNotifications func
        UIApplication.sharedApplication().scheduledLocalNotifications = nil
        
        let cells = tableView.visibleCells() as? [UITableViewCell]
        if cells != nil
        {
            assert( cells!.count==Alarms.sharedInstance.count, "alarms not been updated correctly")
            var count = cells!.count
            while count>0
            {
                if Alarms.sharedInstance[count-1].enabled
                {
                    (cells![count-1].accessoryView as! UISwitch).setOn(true, animated: false)
                    cells![count-1].backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
                else
                {
                    (cells![count-1].accessoryView as! UISwitch).setOn(false, animated: false)
                    cells![count-1].backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                }
                
                count--
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if Alarms.sharedInstance.count == 0
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        else
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        return Alarms.sharedInstance.count

        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editing
        {
            Global.indexOfCell = indexPath.row
            self.tableView.tag = indexPath.row
            performSegueWithIdentifier("editSegue", sender: self)
        }
    }
    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath) as? UITableViewCell
        if  cell == nil {
            cell = UITableViewCell(
            style: UITableViewCellStyle.Subtitle, reuseIdentifier: "AlarmCell")
        }
        cell!.tag = indexPath.row
        let ala = Alarms.sharedInstance[indexPath.row] as Alarm
        cell!.textLabel?.text = ala.timeStr
        cell!.textLabel?.font = UIFont.systemFontOfSize(22.0)
        cell!.detailTextLabel?.text = ala.label

  

        // Configure the cell...
        
        let sw = UISwitch(frame: CGRect())
        //sw.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        //tag is used to indicate which row had been touched
        sw.tag = indexPath.row
        cell!.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        sw.addTarget(self, action: "switchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        if ala.enabled
        {
            sw.setOn(true, animated: false)
        }
        cell!.accessoryView = sw
        
        
        //delete empty seperator line
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        return cell!
    }
    /*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.
    }
    */
    
    
    
    @IBAction func switchTapped(sender: UISwitch)
    {
        if sender.on 
        {
            println("switch on")
            sender.superview?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            Alarms.sharedInstance.setEnabled(true, AtIndex: sender.tag)
            Alarms.sharedInstance.PersistAlarm(sender.tag)
            scheduler.setNotificationWithDate(Alarms.sharedInstance[sender.tag].date, onWeekdaysForNotify: Alarms.sharedInstance[sender.tag].repeatWeekdays, snooze: Alarms.sharedInstance[sender.tag].snoozeEnabled, soundName: Alarms.sharedInstance[sender.tag].mediaLabel)
            
            
        }
        else
        {
            println("switch off")
            sender.superview?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            Alarms.sharedInstance.setEnabled(false, AtIndex: sender.tag)
            Alarms.sharedInstance.PersistAlarm(sender.tag)
            scheduler.reSchedule()
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            Alarms.sharedInstance.removeAtIndex(indexPath.row)
            Alarms.sharedInstance.deleteAlarm(indexPath.row)
            var cells = tableView.visibleCells() as! [UITableViewCell]
            for cell in cells
            {
                var sw = cell.accessoryView as! UISwitch
                if sw.tag > indexPath.row
                {
                    sw.tag -= 1
                }
            }
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dist = segue.destinationViewController as! UINavigationController
        let addEditController = dist.topViewController as! AlarmAddEditViewController
        if segue.identifier == "addSegue"
        {
            addEditController.navigationItem.title = "Add Alarm"
            Global.isEditMode = false
            Global.label = "Alarm"
            Global.mediaLabel = "bell"
            Global.weekdays.removeAll(keepCapacity: true)
            Global.snoozeEnabled = false
        }
        else if segue.identifier == "editSegue"
        {
            addEditController.navigationItem.title = "Edit Alarm"
            Global.isEditMode = true
            //Global.oldLabel = Alarms.sharedInstance[Global.indexOfCell].label
            
            Global.weekdays = Alarms.sharedInstance[Global.indexOfCell].repeatWeekdays
            Global.label = Alarms.sharedInstance[Global.indexOfCell].label
            Global.mediaLabel = Alarms.sharedInstance[Global.indexOfCell].mediaLabel
            Global.snoozeEnabled = Alarms.sharedInstance[Global.indexOfCell].snoozeEnabled
        }
        
        
    }
    
    @IBAction func unwindToMainAlarmView(segue: UIStoryboardSegue) {
        editing = false
        Global.weekdays.removeAll(keepCapacity: true)
        
    }

}
