//
//  LoginViewController.swift
//  FireSwiftAuthentication
//
//
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var lblCaution: UILabel!
    //@IBOutlet weak var txtUser: UITextField!
    //@IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            print(auth)
            if let user = user {
                print(user)
       
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func btnLogin(_ sender: AnyObject) {
        if self.txtUser.text == "" || self.txtPass.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.txtUser.text!, password: self.txtPass.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Nav")
                    self.present(vc, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
 }
 
 
