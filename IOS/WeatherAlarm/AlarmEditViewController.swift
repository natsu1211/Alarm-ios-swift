//
//  AlarmEditViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15/9/21.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit

class AlarmEditViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func cancelEdit(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func editAlarm(sender: AnyObject) {
        let date = datePicker.date
        let timeStr = NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        alarms[index].timeStr = timeStr
        alarms[index].date = date

        UIApplication.sharedApplication().scheduledLocalNotifications = nil
        for alarm in alarms
        {
            if alarm.enabled
            {
                MainAlarmViewController.setNotificationWithDate(alarm.date)
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func deleteAlarm(sender: AnyObject) {
        
        
        alarms.removeAtIndex(index)
        UIApplication.sharedApplication().scheduledLocalNotifications = nil
        for alarm in alarms
        {
            if alarm.enabled
            {
                MainAlarmViewController.setNotificationWithDate(alarm.date)
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    

}
