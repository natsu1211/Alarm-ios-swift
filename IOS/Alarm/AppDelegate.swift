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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate{

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    let alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        var error: NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error1 as NSError{
            error = error1
            print("could not set session. err:\(error!.localizedDescription)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error1 as NSError{
            error = error1
            print("could not active session. err:\(error!.localizedDescription)")
        }
        window?.tintColor = UIColor.red
        
        return true
    }
   
    //receive local notification when app in foreground
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        //show an alert window
        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
        var isSnooze: Bool = false
        var soundName: String = ""
        var index: Int = -1
        if let userInfo = notification.userInfo {
            isSnooze = userInfo["snooze"] as! Bool
            soundName = userInfo["soundName"] as! String
            index = userInfo["index"] as! Int
        }
        
        playSound(soundName)
        //schedule notification for snooze
        if isSnooze {
            let snoozeOption = UIAlertAction(title: "Snooze", style: .default) {
                (action:UIAlertAction)->Void in self.audioPlayer?.stop()
                self.alarmScheduler.setNotificationForSnooze(snoozeMinute: 9, soundName: soundName, index: index)
            }
            storageController.addAction(snoozeOption)
        }
        let stopOption = UIAlertAction(title: "OK", style: .default) {
            (action:UIAlertAction)->Void in self.audioPlayer?.stop()
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
            self.alarmModel = Alarms()
            self.alarmModel.alarms[index].onSnooze = false
            //change UI
            var mainVC = self.window?.visibleViewController as? MainAlarmViewController
            if mainVC == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                mainVC = storyboard.instantiateViewController(withIdentifier: "Alarm") as? MainAlarmViewController
            }
            mainVC!.changeSwitchButtonState(index: index)
        }
        
        storageController.addAction(stopOption)
        window?.visibleViewController?.navigationController?.present(storageController, animated: true, completion: nil)
    }
    
    //snooze notification handler when app in background
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        var index: Int = -1
        var soundName: String = ""
        if let userInfo = notification.userInfo {
            soundName = userInfo["soundName"] as! String
            index = userInfo["index"] as! Int
        }
        self.alarmModel = Alarms()
        self.alarmModel.alarms[index].onSnooze = false
        if identifier == Id.snoozeIdentifier {
            alarmScheduler.setNotificationForSnooze(snoozeMinute: 9, soundName: soundName, index: index)
            self.alarmModel.alarms[index].onSnooze = true
        }
        completionHandler()
    }
    
    //print out all registed NSNotification for debug
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        print(notificationSettings.types.rawValue)
    }
    
    //AlarmApplicationDelegate protocol
    func playSound(_ soundName: String) {
        
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
            nil,
            { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            },
            nil)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
            return
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
    
    //AVAudioPlayerDelegate protocol
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
   
    //UIApplicationDelegate protocol
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        audioPlayer?.pause()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        audioPlayer?.play()
        alarmScheduler.checkNotification()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    



}

