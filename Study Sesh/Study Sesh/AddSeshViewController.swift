//
//  AddSesh.swift
//  Study Sesh
//
//  Created by Marcus Mertilien on 4/17/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit
class AddSeshViewController:UIViewController, UITextFieldDelegate{
   
    @IBOutlet weak var save: UIButton!
    
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Time: UITextField!
    @IBOutlet weak var Members: UITextField!
    
    var sesh: studySesh?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        navigationItem.title = sender.text
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
    
    
}
