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
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    
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
        //not change the title, UUID, mediaID
        let newAlarm = Alarm(label: Alarms.sharedInstance[sender.tag].label, timeStr: timeStr, date: date, enabled: false, UUID: Alarms.sharedInstance[sender.tag].UUID, mediaID: Alarms.sharedInstance[sender.tag].mediaID)
        

        UIApplication.sharedApplication().scheduledLocalNotifications = nil
        for alarm in Alarms.sharedInstance
        {
            if alarm.enabled
            {
                alarmDelegate.setNotificationWithDate(alarm.date)
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func deleteAlarm(sender: AnyObject) {
        
        
        Alarms.sharedInstance.removeAtIndex(index)
        UIApplication.sharedApplication().scheduledLocalNotifications = nil
        for alarm in Alarms.sharedInstance
        {
            if alarm.enabled
            {
                alarmDelegate.setNotificationWithDate(alarm.date)
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    

}
