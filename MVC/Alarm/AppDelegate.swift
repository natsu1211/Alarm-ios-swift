import UIKit
import Foundation
import AudioToolbox
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate{

    var window: UIWindow?
    private var audioPlayer: AVAudioPlayer?
    private let notificationScheduler: NotificationSchedulerDelegate = NotificationScheduler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError{
            print("could not set session. err:\(error.localizedDescription)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError{
            print("could not active session. err:\(error.localizedDescription)")
        }
        window?.tintColor = UIColor.red
        // will ask for user's permission of local notification when this function be called first time,
        // if notification is not permitted, then this app actually cannot work
        notificationScheduler.registerNotificationCategories()
        return true
    }
   
    //receive local notification when app in foreground
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        //show an alert window
        let alertController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
        guard
            let userInfo = notification.userInfo,
            let snoozeEnabled = userInfo["snooze"] as? Bool,
            let soundName = userInfo["soundName"] as? String,
            let uuidStr = userInfo["uuid"] as? String
        else {return}
        
        playSound(soundName)
        //schedule notification for snooze
        if snoozeEnabled {
            let snoozeOption = UIAlertAction(title: "Snooze", style: .default) {
                (action:UIAlertAction) in
                self.audioPlayer?.stop()
                self.notificationScheduler.setNotificationForSnooze(ringtoneName: soundName, snoozeMinute: 9, uuid: uuidStr)
            }
            alertController.addAction(snoozeOption)
        }
        
        let stopOption = UIAlertAction(title: "OK", style: .default) {
            (action:UIAlertAction) in
            self.audioPlayer?.stop()
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
            let alarms = Store.shared.alarms
            if let alarm = alarms.getAlarm(ByUUIDStr: uuidStr) {
                if alarm.repeatWeekdays.isEmpty {
                    alarm.enabled = false
                    alarms.update(alarm)
                }
            }
        }
        
        alertController.addAction(stopOption)
        window?.visibleViewController?.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    //snooze notification handler when app in background
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        guard
            let userInfo = notification.userInfo,
            let soundName = userInfo["soundName"] as? String,
            let uuid = userInfo["uuid"] as? String
        else {return}
        
        switch identifier {
        case Identifier.snoozeActionIdentifier:
            notificationScheduler.setNotificationForSnooze(ringtoneName: soundName, snoozeMinute: 9, uuid: uuid)
            break
        case Identifier.stopActionIdentifier:
            let alarms = Store.shared.alarms
            if let alarm = alarms.getAlarm(ByUUIDStr: uuid) {
                if alarm.repeatWeekdays.isEmpty {
                    alarm.enabled = false
                    alarms.update(alarm)
                }
            }
            break
        default:
            break
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
        
        guard let filePath = Bundle.main.path(forResource: soundName, ofType: "mp3") else {fatalError()}
        let url = URL(fileURLWithPath: filePath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            audioPlayer = nil
            print("audioPlayer error \(error.localizedDescription)")
            return
        }
        
        if let player = audioPlayer {
            player.delegate = self
            player.prepareToPlay()
            //negative number means loop infinity
            player.numberOfLoops = -1
            player.play()
        }
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
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        notificationScheduler.syncAlarmStateWithNotification()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
