//
//  AppDelegate.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation

protocol AlarmApplicationDelegate
{
    //typealias Weekday
    func playAlarmSound()
    func setNotificationWithDate(date: NSDate)
    //something wrong with typealias, use Int instead
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify:[Int])
    func setupNotificationSettings()
    
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate{

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    //var alarmDelegate: AlarmApplicationDelegate?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //alarmDelegate? = self
        //alarmDelegate!.setupNotificationSettings()
        setupNotificationSettings()
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        /*AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
            nil,
            vibrationCallback,
            nil)*/
        
        playAlarmSound()
        //alarmDelegate!.scheduleNotification()
  
        
    }
    
    //print out all registed NSNotification for debug
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        println(notificationSettings.types.rawValue)
    }
    
    //AlarmApplicationDelegate protocol
    func playAlarmSound() {
        if AlarmAddViewController.isVibration{
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        let url = NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("bell", ofType: "mp3")!)
        
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        if let err = error {
            println("audioPlayer error \(err.localizedDescription)")
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
    
    func setupNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if (notificationSettings.types == UIUserNotificationType.None){
            // Specify the notification types.
            var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
            
            
            // Specify the notification actions.
            var stopAction = UIMutableUserNotificationAction()
            stopAction.identifier = "myStop"
            stopAction.title = "OK"
            stopAction.activationMode = UIUserNotificationActivationMode.Background
            stopAction.destructive = false
            stopAction.authenticationRequired = false
            
            var snoozeAction = UIMutableUserNotificationAction()
            snoozeAction.identifier = "mySnooze"
            snoozeAction.title = "Snooze"
            snoozeAction.activationMode = UIUserNotificationActivationMode.Background
            snoozeAction.destructive = false
            snoozeAction.authenticationRequired = false
            
            
            let actionsArray = [UIUserNotificationAction](arrayLiteral: stopAction, snoozeAction)
            
            // Specify the category related to the above actions.
            var alarmCategory = UIMutableUserNotificationCategory()
            alarmCategory.identifier = "myAlarmCategory"
            alarmCategory.setActions(actionsArray, forContext: .Default)
            
            
            let categoriesForSettings = Set(arrayLiteral: alarmCategory)
            
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        }
    }
    
    func setNotificationWithDate(date: NSDate) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        AlarmNotification.alertBody = "alarm"
        AlarmNotification.alertAction = "open app"
        AlarmNotification.category = "myAlarmCategory"
        //AlarmNotification.applicationIconBadgeNumber = 1
        //AlarmNotification.repeatCalendar = calendar
        //TODO, not working
        //AlarmNotification.repeatInterval = NSCalendarUnit.CalendarUnitWeekOfYear
        AlarmNotification.soundName = UILocalNotificationDefaultSoundName
        AlarmNotification.timeZone = NSTimeZone.defaultTimeZone()
        AlarmNotification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
    }
    
    enum Weekdays:Int{
        case Sunday=1, Monday, Tuesday, Wendesday, Thursday, Friday, Saturday
    }
    
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify:[Int])
    {
        //var flags = NSCalendarUnit.CalendarUnitWeekday
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let daysInWeek = 7
        let now = NSDate()
        let flags = NSCalendarUnit.CalendarUnitEra|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitWeekdayOrdinal | NSCalendarUnit.CalendarUnitTimeZone | NSCalendarUnit.CalendarUnitWeekOfMonth | NSCalendarUnit.CalendarUnitWeekOfYear
        var components = calendar.components(flags, fromDate: date)
        var weekday = components.weekday
        var datesForNotification:[NSDate] = [NSDate]()
        for wd in onWeekdaysForNotify
        {
            var wdDate:NSDate!
            if wd < weekday || (wd == weekday && date.compare(now) == NSComparisonResult.OrderedAscending)
            {
                
                wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: wd+daysInWeek-weekday, toDate: date, options:.MatchStrictly)!
                
            }
            else
            {
                wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: wd-weekday, toDate: date, options:.MatchStrictly)!
            }
            datesForNotification.append(wdDate)
        }
        for d in datesForNotification
        {
            setNotificationWithDate(d)
        }
        
    }
    
    //todo,vibration infinity
    func vibrationCallback(id:SystemSoundID, _ callback:UnsafeMutablePointer<Void>) -> Void
    {
        print("callback")
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully
        flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!,
        error: NSError!) {
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer!) {
    }
    
    
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

