//
//  LoginViewController.swift
//  FireSwiftAuthentication
//
//
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {
    
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
    
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        if self.txtUser.text == "" || self.txtPass.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: txtUser.text!, password: txtPass.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Nav")
                    self.present(vc, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}



