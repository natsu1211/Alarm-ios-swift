//
//  WeekdaysViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15/10/15.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit

class WeekdaysViewController: UITableViewController {
    
    static func repeatText() -> String
    {
        
        if Global.weekdays.count == 7
        {
            return "Every day"
        }
        
        if Global.weekdays.isEmpty
        {
            return "Never"
        }
        
        
        
        var ret = String()
        var weekdaysSorted:[Int] = [Int]()
        
        weekdaysSorted = Global.weekdays.sorted(by: <)
        
        
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        for weekday in Global.weekdays
        {
            if weekday == (indexPath.row + 1) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        
       
        return cell
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        //for swift 1.2, if you are using swift 2.0, use indexOf:. method instead
        
        if let index = Global.weekdays.index(of: (indexPath.row + 1)){
          Global.weekdays.remove(at: index)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else{
            //row index start from 0, weekdays index start from 1 (Sunday), so plus 1
            Global.weekdays.append(indexPath.row + 1)
            //Alarms.sharedInstance[Global.indexOfCell].repeatWeekdays.append(indexPath.row + 1)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
    }
}
