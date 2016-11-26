//
//  MusicTableViewController.swift
//  Alarm-ios8-swift
//
//  Created by longyutao on 16/2/3.
//  Copyright (c) 2016年 LongGames. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaTableViewController: UITableViewController, MPMediaPickerControllerDelegate  {
    
    fileprivate let musicIdentifier = "musicIdentifier"
    fileprivate let numberOfRingtones = 2
    var mediaItem: MPMediaItem?
    static func mediaText() -> String
    {
        
        return Global.mediaLabel
       
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0
        {
            return 1
        }
        
        else if section == 1
        {
            return 2
        }
        else
        {
            return numberOfRingtones
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return nil
        }
        else if section == 1
        {
            return "SONGS"
        }
        else
        {
            return "RINGTONS"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(
            withIdentifier: musicIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(
                style: UITableViewCellStyle.default, reuseIdentifier: musicIdentifier)
        }
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
                cell!.textLabel!.text = "Buy More Tones"
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 1
            {
                cell!.textLabel!.text = "Pick a song"
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                cell!.textLabel!.text = "bell"
            }
            else if indexPath.row == 1
            {
                cell!.textLabel!.text = "tickle"
            }
            if cell!.textLabel!.text == Global.mediaLabel
            {
                cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.anyAudio)
        mediaPicker.delegate = self
        mediaPicker.prompt = "Select any song!"
        mediaPicker.allowsPickingMultipleItems = false
        if indexPath.section == 1
        {
            if indexPath.row == 1
            {
                
                self.present(mediaPicker, animated: true, completion: nil)
            }
        }
        
        let c = tableView.cellForRow(at: indexPath)
        let cells = tableView.visibleCells 
        for cell in cells
        {
            let indexP = tableView.indexPath(for: cell)
            if indexP?.section == 2
            {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        
        if indexPath.section == 2
        {
            c?.accessoryType = UITableViewCellAccessoryType.checkmark
            Global.mediaLabel = c!.textLabel!.text!
        }
    }
    
    
    /*
    MPMediaPickerControllerDelegate
    */
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems  mediaItemCollection:MPMediaItemCollection) -> Void
    {
        if !mediaItemCollection.items.isEmpty
        {
            let aMediaItem = mediaItemCollection.items[0]
        
            self.mediaItem = aMediaItem
            Alarms.sharedInstance[Global.indexOfCell].mediaID = (self.mediaItem?.value(forProperty: MPMediaItemPropertyPersistentID)) as! String
            //fillData(aMediaItem);
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
