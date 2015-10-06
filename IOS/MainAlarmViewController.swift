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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //alarms.append(alarm)
        UIApplication.sharedApplication().scheduledLocalNotifications = nil
        
        super.viewWillAppear(animated)
        tableView.reloadData();
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
        return Alarms.sharedInstance.count
        
    }
    

    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let rowValue = alarms[indexPath.row].timeStr
            let message = "You selected \(rowValue)"
            let controller = UIAlertController(title: "Row Selected",
            message: message, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Yes I Did",
            style: .Default, handler: nil)
            controller.addAction(action)
            presentViewController(controller, animated: true, completion: nil)
    }
    */

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath) as! UITableViewCell
        
            //cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "AlarmCell")
            cell.tag = indexPath.row
            let ala = Alarms.sharedInstance[indexPath.row] as Alarm
            cell.textLabel?.text = ala.timeStr
            cell.detailTextLabel?.text = ala.title
        
        

        // Configure the cell...
        
        let sw = UISwitch(frame: CGRect())
        //tag is used to indicate which row had been touched
        
        sw.tag = indexPath.row

        //cell.detailTextLabel?.text = ala.time
        cell.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        sw.addTarget(self, action: "SwitchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.accessoryView = sw
        
        return cell
    }
    /*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.
    }
    */
    
    
    
    @IBAction func SwitchTapped(sender: UISwitch)
    {
        if sender.on 
        {
            println("switch on")
            sender.superview?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            Alarms.sharedInstance[sender.tag].enabled = true
            alarmDelegate.setNotificationWithDate(Alarms.sharedInstance[sender.tag].date)
            
            
        }
        else
        {
            println("switch off")
            sender.superview?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            Alarms.sharedInstance[sender.tag].enabled = false
            //UIApplication.sharedApplication().cancelLocalNotification(UIApplication.sharedApplication().scheduledLocalNotifications[sender.tag] as! UILocalNotification)
            UIApplication.sharedApplication().scheduledLocalNotifications = nil
            for alarm in Alarms.sharedInstance{
                if alarm.enabled{
                alarmDelegate.setNotificationWithDate(alarm.date)
                }
            }
            
            
        }
        //sender.tag
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        let tableViewCell = sender as? UITableViewCell
        if tableViewCell == nil{
            return
        }
        let indexPath = tableView.indexPathForCell(tableViewCell!)!
        let dist =  segue.destinationViewController as! AlarmEditViewController
        dist.index = indexPath.row
    }

}
