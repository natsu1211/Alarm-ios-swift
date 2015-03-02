//
//  MainAlarmViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
var alarms: [Alarm] = [Alarm]()

class MainAlarmViewController: UITableViewController {
    
    
    
    let alarm = Alarm(title: "test", time: "")
    
    @IBAction func AddAlarm(sender: AnyObject) {
        var timePicker = UIPickerView()
        //timePicker.dataSource = self
        //timePicker.delegate = self
        alarms.append(alarm)
        tableView.reloadData();
        
    }
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //alarms.append(alarm)

        super.viewWillAppear(animated)
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return alarms.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let ala = alarms[indexPath.row] as Alarm
        let sw = UISwitch(frame: CGRect())
        sw.tag = indexPath.row
        cell.textLabel?.text = ala.title + "          " + ala.time
        //cell.detailTextLabel?.text = ala.time
        cell.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.9)
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
        if sender.on == true
        {
            println("switch on")
            sender.superview?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        else
        {
            println("switch off")
            sender.superview?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.9)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
