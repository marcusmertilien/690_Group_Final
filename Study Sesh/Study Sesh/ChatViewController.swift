//
//  ChatViewController.swift
//  Study Sesh
//
//  Created by Shyran on 5/13/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, FetchData{
    @IBOutlet weak var myTable: UITableView!
    private var contacts = [Contact]();
    private var Chat_Segue = "ChatSegue";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBfirebase.Instance.delegate = self;
        DBfirebase.Instance.getContacts();
    }
    func dataReceived(contacts:[Contact]) {
        self.contacts = contacts;
        
        for contact in contacts{
            if contact.id == FBAuth.Instance.userID(){
                FBAuth.Instance.userName = contact.name
            }
        }
        
        myTable.reloadData();
    }
    
    func tableView(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row].name + " @ " + contacts[indexPath.row].time + " Course: " + contacts[indexPath.row].course 
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Chat_Segue, sender: nil)
    }
    
    
}
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: CHAT_SUGUE, sender: nil)
//    }

