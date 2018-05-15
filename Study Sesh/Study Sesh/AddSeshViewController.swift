//
//  AddSesh.swift
//  Study Sesh
//
//  Created by Marcus Mertilien on 4/17/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit
import os.log
import Foundation
import Firebase
import FirebaseDatabase

class AddSeshViewController:UIViewController, UITextFieldDelegate{
   
   
    
<<<<<<< HEAD
    //@IBOutlet weak var save: UIBarButtonItem!
=======
>>>>>>> feat_Cosmetics
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Time: UITextField!
    @IBOutlet weak var Members: UITextField!
    
    var sesh: studySesh?
    
    let datePicker = UIDatePicker()
    let memberPicker = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        //Disable Save Button From Begining
        save.isEnabled = false
        
        //Establish Delegates
        Location.delegate = self as UITextFieldDelegate
        Time.delegate = self as UITextFieldDelegate
        Members.delegate = self as UITextFieldDelegate
        
        if let localSesh = sesh{
            Location.text = localSesh.location
            Time.text = localSesh.time
        }
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        //navigationController?.toolbar.isHidden = false
//    }
   
    func createMemberPicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Done button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
    }
    
   
    
    func createDatePicker(){
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Done button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        Time.inputAccessoryView = toolbar
        Time.inputView = datePicker
        
        //Format Picker
        datePicker.datePickerMode = .time
    }
    
    @objc func donePressed(){
        //Format Date
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dateString = formatter.string(from: datePicker.date)
        Time.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        //Disable the Save button while editing.
        
        if(textField == Location){
            print (" Location text Field Did Begin Editing")
        }else if (textField == Time){
            print (" Timed text Field Did Begin Editing")
        }
        
        save.isEnabled = false
        
        print ("Save Disabled")
        
    }
    
    
    func textFieldBeginEditing(_ sender: UITextField) {
        //Disable the Save button while editing.
        
        if(sender == Location){
            print (" Location text Field Did Begin Editing")
        }else if (sender == Time){
            print (" Timed text Field Did Begin Editing")
        }else if (sender == Members){
            print ("Members text Field Did Begin Editing")
        }
        
        save.isEnabled = false
        
        print ("Save Disabled")
    }
    
    
     func textFieldDidEndEditing(_ sender: UITextField) {
        //Update Save Button
        updateSaveButton()
        print ("\nUpdate Save Called")
        
        if(sender == Location){
            print (" \nLocation text Field Did End Editing")
        }else if (sender == Time){
            print (" \nTimed text Field Did End Editing")
        }else if (sender == Members){
            print (" \nMembers text Field Did End Editing")
        }
    }
    
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    private func updateSaveButton(){
        //Disarm the save button if the text field is empty
        let location = Location.text ?? ""
        let time = Time.text ?? ""
        let members = Members.text ?? ""
        
        print("\n\nUpdate Save Button Called")
        print ("\nLocation: " ,!location.isEmpty)
        print ("\nTime: " , !time.isEmpty)
        print ("\nMembers: ", !members.isEmpty)
        
        save.isEnabled = (!location.isEmpty && !time.isEmpty &&
            !members.isEmpty)
    }
    
//Prepare for return from segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === save else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
          
            return
        }
        
        guard (sender as? UIBarButtonItem) != nil else {
            os_log("Something unforseable has gone wrong", log: OSLog.default, type: .debug)
            
            return
        }
        
        let location = Location.text ?? ""
        let time = Time.text ?? ""
        //let members = Members.text ?? ""
        
        sesh = studySesh(location: location, time: time)
    }
    
}
