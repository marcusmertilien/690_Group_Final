//
//  LoginControllerView.swift
//  Study Sesh
//
//  Created by Shyran on 4/26/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bottomLayoutGuideConstraint: NSLayoutConstraint!
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Actions
    
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        if nameField?.text != "" {
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if let err:Error = error {
                    print(err.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "Login", sender: nil)
            })
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //let navVc = segue.destination as! UINavigationController
        //let channelVc = navVc.viewControllers.first as! ChannelListViewController
        
        //channelVc.senderDisplayName = nameField?.text
    }
    
    // MARK: - Notifications
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        let keyboardEndFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        bottomLayoutGuideConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
    }
    
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        bottomLayoutGuideConstraint.constant = 48
    }
}

