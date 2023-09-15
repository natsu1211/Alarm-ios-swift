# Alarm-ios-swift     

Partially clone of Apple's built-in alarm app in swift.    

- Almost the same UI as the Apple's official alarm app (old version)
    - In newer IOS, Apple changed the style of DatePicker, which I think too small to click.
    - No new added HealthKit functionality.
- Add, Delete, Edit Alarm (One shot and Repeating). Snooze.
- Local ringtone selection only. No access to music app library.
- Text not localized. English Only. But NSLocal is used for further localization.

As far as I know, it's impossible to make a full clone of official alarm app using existing APIs.    
The major issues are,    
- Third-party alarm app rely on notification to notify user, whether local or remote. However, notifacation cannot override the ringer switch behaviour nor can they override “Do Not Disturb” mode, which means your alarm app may could not even make any sound. Moreover, User may disallow your app to send notificaiton, which make the alarm app just useless.
- Notification cannot wake up the app, it depends on whether user response to the notifacation to bring your alarm app to foreground. moreover, Notification sounds have a maximum duration of 30 seconds. This means that once the 30 seconds is up, no more sound. If user just ignore or failed to reponse before the notification dismissed, the alarm app could not do anything more. No snooze, no sound, which is critical to an alarm app. 
- Applications cannot set the volume above or below the devices set volume, nor can it suppress the sounds of other applications.

however, I believe you can still get something useful from this project, if you are new to ios app development.
- How to organize app in MVC or MVVM architecture, which means carefully design the data flow of your app and make your codebase easy to maintain.
    - Though a lot of new architectures there to choose nowadays, MVC or MVVM is still the one easy to apply to your existing code and useful.
- How to schedule and handle local notification correctly.
- How to use UITableView.
- Storyboard-based view transition.
- some Swift features, like ``, `extesnion`, `parttern match`, 

## Demo     
<img src="https://user-images.githubusercontent.com/3120754/268233418-b9319d24-aeab-4fa6-a872-3155e5193b96.gif" width="45%" height="45%"> 

## Branch     
`main`      
Main branch. Contains implementations in MVC and MVVM architecture.    
SwiftUI version and more test case will be added in future.

`below-ios10.0`         
Only contains implementation in MVC. Using old local notification APIs deprecated since IOS 10.0.    
Behaves almost the same as new APIs.    
*Caution: Not well tested and not maintained anymore. Reference use only.*

## Technical Details
I wrote this app in 2016 to learn iOS development and Swift. That year, iOS 10 was released, and the Swift language had just been made public. Since I am a console game developer and not a mobile app developer, after completing the interface and basic functions of this app, I lost interest in maintaining this project. 

But over the years, I've written numerous desktop editors using the MVVM architecture in my work, and I've learned about the design philosophies and pros and cons of various architectures. I also realized that I made so many mistakes when writing this app back then. Since this project has unexpectedly accumulated hundreds of stars over the years, in order to avoid misleading beginners, I made up my mind and spent some time refactoring this app. 

I've tried to align it with the design of both MVC and MVVM architectures. Implementations under these two architectures can be found in folders with the same name.

### MVC
When we develop iOS applications using the UIKit, our program is essentially already in the MVC architecture. However, simply organizing our application into the three parts of View, Model, and Controller does not necessarily make our application easier to maintain. We also need to consider how and when the Model changes when a user interacts with the UI, as well as other parts of the UI.

Take this alarm clock application as an example. Users can delete an alarm on the main scene, and they can also delete it on the editing scene. These two interfaces have different Controllers, so naturally, they have different code to handle the user's delete action. The most straightforward implementation would be to add the corresponding processing code (such as delete, updating the TableView, updating Notifications, etc.) wherever a user might delete the alarm.    
However, this often results in duplicated code. In more complex Apps, users might have multiple ways to achieve a function. If we just add similar handling code wherever user input is processed, then redundant code would be scattered everywhere.

But take a while, we can find no matter how the user deletes the alarm, what we ultimately need to do is remove the corresponding Alarm from our Model. We can set some rules for ourselves, or rather, change the order of processing. That is, we don't changed the model and view in the same place. We handle the user actions, only change the state of the Model, and other UI need to change are automatically adjusted by observing changes of the Model. Moreover, the operations that can be performed on the Model (such as add, delete, update) are often far fewer than the actions a user can make on the interface. This means we need even less code to update the UI in one place, which makes our codebase easier to maintain. That's the basic thinking of MVC and lots of other architectures.


#### Model
The Model of this App is straightforward, comprising just three classes. 

The `Alarm` class represents a single Alarm and defines various attributes needed for an individual Alarm. 

The `Alarms` class represents all alarms, and internally, it simply contains an array of Alarm instances. The `Alarms` class also defines several helper methods, such as `add`, `remove`, and `update`, which are called in the handler of user's operations on the Alarm. 

The `Store` class is responsible for serializing and deserializing the `Alarms` class, allowing us to save and load alarms added by the user. This ensures that added and edited Alarms don't disappear and are displayed correctly when the app is opened next time.    
In terms of implementation details, since we implemented the `Codable` Protocol for the `Alarm` and `Alarms` classes, we can use `JSONEncoder` and `JSONDecoder` to easily serialize the `Alarm` and Alarms classes into JSON strings. These JSON strings are then saved to the phone's storage space via UserDefaults. When the Store class is instantiated, it is also responsible for retrieving the serialized Alarms from UserDefaults, deserializing them, and constructing instance of `Alarms`. Throughout the entire lifecycle of the app, there is only one instance of both Store and Alarms. To be clear, when we write something like `let alarms = Store.shared.alarms`, we are just copy the reference to the instance, not creating a new instance.


#### View
Regarding the View, there isn't much to say. The View in this app is entirely based on Storyboard. We can intuitively layout the UI in the Storyboard and also set up the transitions between different scenes (Apple calls it "Segue"). 

Setting aside SwiftUI, even though we can also use XIB and pure code to construct the UI, relying mainly on Storyboard is usually a better choice. We can prepare everything in advance, and when a scene transition is needed, we simply call the `performSegue` function. One point worth mentioning is, if you're puzzled about how to pass required data during transitions, consider defining the data to be passed as properties of the target ViewController. Then, in the `prepare` function (which gets invoked before the `performSegue` function), you can retrieve the instance of the target ViewController and directly assign values to these properties.

#### Controller
In an MVC iOS app, the ViewController acts as the Controller. It holds reference to the View and is responsible for processing user actions. At the same time, it also holds reference to the Model and can make changes to it. As mentioned earlier, the key to making MVC successful is that, within the handler processing user actions, we only make changes to the Model, rather than directly altering other UI elements. Other UI elements are updated by monitoring changes to the Model. 

While there are many ways to achieve this goal, in this app, we use the `NotificationCenter` from `Foundation` to do so. Within this app, when the Model has a change, it will post a notification (not a Local Notification) through the `Store` class to inform observers. This notification contains details on which Alarm changed and the reason of the change (whether it was added, deleted, or updated). Observers of the notification can then process accordingly. You can find the relevant code in the `MainAlarmViewController`.

The crucial part involves the subscription code,
```swift
NotificationCenter.default.addObserver(self, selector: #selector(handleChangeNotification(_:)), name: Store.changedNotification, object: nil)
```
and the subsequent handling after receiving a notification.
```swift
    @objc func handleChangeNotification(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        // Handle changes to contents
        if let changeReason = userInfo[Alarm.changeReasonKey] as? String {
            let newValue = userInfo[Alarm.newValueKey]
            let oldValue = userInfo[Alarm.oldValueKey]
            switch (changeReason, newValue, oldValue) {
            case let (Alarm.removed, (uuid as String)?, (oldValue as Int)?):
                tableView.deleteRows(at: [IndexPath(row: oldValue, section: 0)], with: .fade)
                if alarms.count == 0 {
                    self.navigationItem.leftBarButtonItem = nil
                }
                scheduler.cancelNotification(ByUUIDStr: uuid)
            case let (Alarm.added, (index as Int)?, _):
                tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.navigationItem.leftBarButtonItem = editButtonItem
                let alarm = alarms[index]
                scheduler.setNotification(date: alarm.date, ringtoneName: alarm.mediaLabel, repeatWeekdays: alarm.repeatWeekdays, snoozeEnabled: alarm.snoozeEnabled, onSnooze: false, uuid: alarm.uuid.uuidString)
            case let (Alarm.updated, (index as Int)?, _):
                let alarm = alarms[index]
                let uuid = alarm.uuid.uuidString
                if alarm.enabled {
                    scheduler.updateNotification(ByUUIDStr: uuid, date: alarm.date, ringtoneName: alarm.mediaLabel, repeatWeekdays: alarm.repeatWeekdays, snoonzeEnabled: alarm.snoozeEnabled)
                } else {
                    scheduler.cancelNotification(ByUUIDStr: uuid)
                }
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            default: tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
```
We only need to update the UITableView within this function, eliminating the need to write UITableView update code in every view action handler.

#### Local Notification
As previously mentioned, this app uses Local Notification to alert users when the alarm time is reached. 

Local Notifications are dispatched at predefined dates and times to present content that the user might be interested in. Upon receiving a Local Notification, the system will display it differently depending on the current state of the phone. Subsequently, based on how users respond to the notification, the app's required actions may differ. For instance, when the phone is locked, the notification will appear in the Notification Center. However, when the phone is unlocked, it will show as a banner at the top of the screen (assuming the user has granted the app permission to send notifications and to display them in this manner). 

Additionally, starting from iOS 8.0, Local Notification can include Actions, allowing users to respond directly without opening the app. Initially, Actions could only accompany buttons, but in recent versions of iOS, notifications can even include images and videos. In this app, we utilize the Action feature to allow users to turn off the alarm or snooze it. A Action must belongs to a `UNNotificationCategory`, and every Local Notification will have a category, let the system knows which Actions the Notification should have. 

The app handle Local Notification at `AppDelegate`. When our app is in the foreground, we can directly handle Notifications within `func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)`. At this case, we use `AVAudioPlayer` to play the ringtone in an infinite loop until the user responds. In this scenario, our app can function as an alarm clock. However, in practical use, users are unlikely to always keep an alarm clock app in the foreground.    
When in the background, several situations might arise. Firstly, as mentioned earlier, when the app is in the background and system receives a notification sent by it, the notification will appear as a banner at the top of screen, which only lasts for a few seconds. If the user taps on the banner before it disappears, our app will be brought to the foreground, reverting to the situation described above.    
If the user long-presses the banner, it will display the Actions associated with that notification. Here, we have set two Actions: Snooze and OK. If the user taps on the Snooze button, it essentially schedules a Local Notification to be sent 9 minutes later. Choosing OK simply turns off that Alarm. Actions can be handled within `func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)`.    
If the user doesn't manage to handle the notification in time or ignores it, we can't do any further processing. After the longest 30-second ringtone ends, users won't hear any more sound. In any case, we can't replicate the actions of the built-in alarm clock app. we can only try to simulate its functions through some workarounds.

It's important to note that any app intending to send Local Notifications must first obtain the user's permission. In this app, we request permission to send notifications the first time the app is launched, by calling `requestAuthorization()`. The system will prompt the user with an alert window, asking them to choose whether or not to grant this permission. If the user accidentally clicks "No," then the app will be unable to send Local Notifications, make it useless. This is also one of the reasons why third-party alarm clock apps can't function the same way as the built-in system ones. It's a feature of iOS, and there's not much we can do about it (although you might consider prompting the user with a pop-up explaining why this permission is so crucial, in hopes that they might go to settings and change the permission setting).

The methods for requesting user permissions and scheduling notifications may vary based on the iOS version. After iOS 10, Apple redesigned the Notification-related APIs. The `main` branch contains the latest approach, while the `below-ios10.0` branch includes the methods used before iOS 10.0. Of course, given that iOS 10.0 is quite dated now, you likely won't need to know the older methods. Implementations related to Local Notification can be found at `NotificationScheduler.Swift`.

### MVVM



## License      
MIT

