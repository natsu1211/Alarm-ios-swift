//
//  labelEditViewController.swift
//  Alarm-ios8-swift
//
//  Created by longyutao on 15/10/21.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit

class LabelEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var labelTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
        self.labelTextField.delegate = self
        
        labelTextField.text = Global.label
        
        //defined in UITextInputTraits protocol
        labelTextField.returnKeyType = UIReturnKeyType.Done
        labelTextField.enablesReturnKeyAutomatically = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //add a ! to avoid conflict of signature of function, likely a bug for swift 1.2
    //func textFieldDidEndEditing(textField: UITextField) -> Bool! {
    //    Alarms.sharedInstance[MainAlarmViewController.indexOfCell].label = textField.text
    //    return true
    //}
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        
        Global.label = textField.text

        //Becuase segue push is used
        navigationController?.popViewControllerAnimated(true)
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
