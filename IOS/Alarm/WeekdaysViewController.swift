//
//  WeekdaysViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15/10/15.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit

class WeekdaysViewController: UITableViewController {
    static var weekdays: [Int] = [Int]()
    static func repeatText() -> String
    {
        
        if !AlarmAddEditViewController.isEditMode
        {
            if WeekdaysViewController.weekdays.count == 7
            {
                return "Every day"
            }
            if WeekdaysViewController.weekdays.isEmpty
            {
                return "Never"
            }
        }
        else
        {
            if Alarms.sharedInstance[MainAlarmViewController.indexOfCell].repeatWeekdays.count == 7
            {
                return "Every day"
            }
            
            if Alarms.sharedInstance[MainAlarmViewController.indexOfCell].repeatWeekdays.isEmpty
            {
                return "Never"
            }
        }
        
        
        var ret = String()
        var weekdaysSorted:[Int] = [Int]()
        if !AlarmAddEditViewController.isEditMode
        {
            weekdaysSorted = WeekdaysViewController.weekdays.sorted(<)
        }
        else
        {
           weekdaysSorted = Alarms.sharedInstance[MainAlarmViewController.indexOfCell].repeatWeekdays.sorted(<)
        }
        
        for day in weekdaysSorted
        {
            switch day{
            case 1:
                ret += "Sun "
            case 2:
                ret += "Mon "
            case 3:
                ret += "Tue "
            case 4:
                ret += "Wed "
            case 5:
                ret += "Thu "
            case 6:
                ret += "Fri "
            case 7:
                ret += "Sat "
            default:
                //throw
                break
            }
        }
        return ret
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        WeekdaysViewController.weekdays.removeAll(keepCapacity: true)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if AlarmAddEditViewController.isEditMode
        {
            // Configure the cell...
            for weekday in Alarms.sharedInstance[MainAlarmViewController.indexOfCell].repeatWeekdays{
                if weekday == (indexPath.row + 1) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            }
        }
        else
        {
            for weekday in WeekdaysViewController.weekdays
            {
                if weekday == (indexPath.row + 1) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            }
        }
       
        return cell
    }


    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if !AlarmAddEditViewController.isEditMode
        {
             if let index = find(WeekdaysViewController.weekdays, (indexPath.row + 1))
             {
                WeekdaysViewController.weekdays.removeAtIndex(index)
                cell.setSelected(true, animated: true)
                cell.setSelected(false, animated: true)
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else
             {
                WeekdaysViewController.weekdays.append(indexPath.row + 1)
                cell.setSelected(true, animated: true)
                cell.setSelected(false, animated: true)
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        //for swift 1.2, if you are using swift 2.0, use indexOf:. method instead
        else
        {
            if let index = find(Alarms.sharedInstance[MainAlarmViewController.indexOfCell].repeatWeekdays, (indexPath.row + 1)){
              Alarms.sharedInstance[MainAlarmViewController.indexOfCell].repeatWeekdays.removeAtIndex(index)
                cell.setSelected(true, animated: true)
                cell.setSelected(false, animated: true)
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else{
                //row index start from 0, weekdays index start from 1 (Sunday), so plus 1
                WeekdaysViewController.weekdays.append(indexPath.row + 1)
                Alarms.sharedInstance[MainAlarmViewController.indexOfCell].repeatWeekdays.append(indexPath.row + 1)
                cell.setSelected(true, animated: true)
                cell.setSelected(false, animated: true)
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            }
        }
        

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let vc = sender as! UITableViewController
    }
    */

}
