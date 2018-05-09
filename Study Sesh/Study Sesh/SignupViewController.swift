//
//  LoginViewController.swift
//  FireSwiftAuthentication
//
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseAnalytics

class SignupViewController: UIViewController {
    
    @IBOutlet weak var lblCaution: UILabel!
    //@IBOutlet weak var txtUser: UITextField!
    //@IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    var ref: FIRApp!
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRApp(named:"https://study-sesh-csc690.firebaseio.com/")
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
        
        let users = txtUser.text
        let pass = txtPass.text
        
        if self.txtUser.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()!.createUser(withEmail: users!, password: pass!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    //let userId = (FIRAuth.auth()?.currentUser?.uid)!
                    //let var ref: FIRDatabaseReference?
                    //ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                      //  print(snapshot.childSnapshot(forPath: "name").value as! String)
                        //print(snapshot.childSnapshot(forPath: "any place you would like to query from").value as! String)
                    //})
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                   /*
                    let userDB = FIRDatabase.database().reference().child("User")
                    let userDictionary : NSDictionary = ["Sender" : FIRAuth?.auth().currentUser!.email as String!, "UserBody" : txtUser.text!]
                    userDB.childByAutoId().setValue(userDictionary) {
                        (error, ref) in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            print("User saved successfully!")
                        }
                    }
                    */

                    FIRDatabase.database().reference().child("users").child((user?.uid)!).setValue(users)
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



