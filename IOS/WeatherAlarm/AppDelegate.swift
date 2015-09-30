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
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |
            UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        /*var alert = UIAlertView();
        alert.title = "Get Notification";
        alert.message = notification.alertBody;
        alert.addButtonWithTitle(notification.alertAction!);
        alert.show()*/
        
        
        
        /*AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
            nil,
            vibrationCallback,
            nil)*/
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
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        }
        audioPlayer?.play()
        
        
        
        
        
    }
    
    
    func vibrationCallback(id:SystemSoundID, _ c:UnsafeMutablePointer<Void>) -> Void
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

