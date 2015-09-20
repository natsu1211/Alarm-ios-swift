//
//  AlarmAddViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-3-2.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer


class AlarmAddViewController: UIViewController, MPMediaPickerControllerDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    var mediaItem: MPMediaItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
        //mediaPicker.delegate = self
       // mediaPicker.prompt = "Select any song!"
       // mediaPicker.allowsPickingMultipleItems = false
        //presentViewController(mediaPicker, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAlarm(sender: AnyObject) {
        let date = datePicker.date
        let timeStr = NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        alarms.append( Alarm(title: "Alarm\(alarms.count+1)", timestr: timeStr, time: date, enabled: false, media: mediaItem))
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    
    @IBAction func backToMain(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
    MPMediaPickerControllerDelegate
    */
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems  mediaItemCollection:MPMediaItemCollection) -> Void
    {
        var aMediaItem = mediaItemCollection.items[0] as! MPMediaItem
        /*if (( aMediaItem.artwork ) != nil) {
            mediaImageView.image = aMediaItem.artwork.imageWithSize(mediaCell.contentView.bounds.size);
            mediaImageView.hidden = false;
        }*/
        
        self.mediaItem = aMediaItem;
        //fillData(aMediaItem);
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

}
