//  ViewController.swift
//  Study Sesh
//
//  Created by Marcus Mertilien on 4/16/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase
import FirebaseAuth


class AppointmentViewController: UITableViewController {
    
    var seshs = [studySesh]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let saveSeshs = loadSeshs(){
            seshs = saveSeshs
        }
    }


//Table Cells
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seshs.count   //This value will change pending on how many elements are read from database. i.e list.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{//Writes data to each cell from seshs
        let cellID = "seshCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SeshCell else{
            fatalError("The Dequed cell is not an instance of taskCell.")
        }
        
        let sesh = seshs[indexPath.row]
        
        cell.Location.text = sesh.location
        cell.Time.text = sesh.time
        
        return cell
    }
    
    
//Data Handling prior to Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
        switch(segue.identifier ?? ""){
        
        case "AddSesh":
            os_log("Adding a new sesh", log: OSLog.default, type: .debug)
            
        case "EditSesh":
            os_log("Edit a new task", log: OSLog.default, type: .debug)
            let editController =  segue.destination as! AddSeshViewController
            
            let selectedSeshCell = sender as? SeshCell
            
            let indexPath = tableView.indexPath(for: selectedSeshCell!)
            
            let selectedSesh = seshs[(indexPath?.row)!]
            editController.sesh = selectedSesh
            
        default:
            break
        }
    }
    
    
    //logout firebase
    @IBAction func logOutAction(sender: AnyObject) {
        if FIRAuth.auth()?.currentUser != nil {
            do{
                try FIRAuth.auth()?.signOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                    self.present(vc, animated: true, completion: nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        
        }
    }
    
    
    //Data Handling post Segue
    @IBAction func editUnwindSegue(sender: UIStoryboardSegue) {
        print(sender.source)
        if let sourceViewController = sender.source as? AddSeshViewController, let sesh = sourceViewController.sesh{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //Update an existing task
                seshs[selectedIndexPath.row] = sesh
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            }else{
                // Add a new sesh.
                let newIndexPath = IndexPath(row: seshs.count, section: 0)
                
                seshs.append(sesh)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveSeshs()
        }
    }
    
    
//Temporary Test Data
    private func loadSampleTasks(){
        let sesh1 = studySesh(location: "Lib", time: "3pm")
        let sesh2 = studySesh(location: "Student Union", time: "12pm")
        let sesh3 = studySesh(location: "CS Lab", time: "8am")
        
        
        seshs.append(sesh1!)
        seshs.append(sesh2!)
        seshs.append(sesh3!)
        
    }
    
   func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
    
        return randomString
    }
    
//Saving Data Locally
    private func saveSeshs(){

      //  let arrSize = seshs.count
        
        
        let userID = FIRAuth.auth()?.currentUser!.uid
        //let seshID = Fir

        
        for(_,element) in seshs.enumerated(){
            let loc = element.location
            let tim = element.time

            
            DBfirebase.Instance.saveSesh(withID: randomString(length: 15), loc: loc!,time: tim!)
            
        }

        let goodSave = NSKeyedArchiver.archiveRootObject(seshs, toFile: studySesh.ArchiveURL.path)
        if goodSave{
            os_log("Seshs saved.", log: OSLog.default,type: .debug)
        }else{
            os_log("Failed to save sehs...", log: OSLog.default, type: .error)
        }
         
 
 
 
    }

//Loading Local Data
    private func loadSeshs() -> [studySesh]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: studySesh.ArchiveURL.path) as?
            [studySesh]
    }
    
}



