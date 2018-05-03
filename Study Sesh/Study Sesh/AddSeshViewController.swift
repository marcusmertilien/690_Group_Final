//
//  AddSesh.swift
//  Study Sesh
//
//  Created by Marcus Mertilien on 4/17/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit
class AddSeshViewController:UIViewController{
    
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Time: UITextField!
    @IBOutlet weak var Members: UITextField!
    
    var sesh: studySesh?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Establish Delegates
        Location.delegate = self as? UITextFieldDelegate
        Time.delegate = self as? UITextFieldDelegate
        Members.delegate = self as? UITextFieldDelegate
        
        
        Location.text = "You Have Arrived"
        Time.text = "12:00pm"
        Members.text = "Billy Bob Joe"
    }
    
    
}
