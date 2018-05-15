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
            if FIRAuth.auth()?.currentUser != nil{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Nav")
                self.present(vc, animated: true, completion: nil)
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
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let user = self.txtUser.text
        let password = self.txtPass.text
        
        self.view.endEditing(true)
        self.lblCaution?.text = ""
        
        FIRAuth.auth()?.createUser(withEmail: user!, password: password!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                
            }
            else if let user = user {
                print(user)
               
            }
        }
    }
 }
 
 
