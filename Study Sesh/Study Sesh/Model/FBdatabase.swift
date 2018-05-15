//
//  FBdatabase.swift
//  Study Sesh
//
//  Created by Shyran on 5/13/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

protocol FetchData:class {
    func dataReceived(contacts: [Contact]);
}

class DBfirebase{
    private static let _instance = DBfirebase();
    
    weak var delegate:FetchData?
    
    private init(){}
    
    static var Instance: DBfirebase{
        return _instance
    }
    var dbRef: FIRDatabaseReference{
        return FIRDatabase.database().reference();
    }
    var userRef: FIRDatabaseReference{
        return dbRef.child("users")
    }
    
    var seshsRef: FIRDatabaseReference{
        return dbRef.child("seshs")
    }
    
    var chatRef: FIRDatabaseReference{
        
        return seshsRef.child("course")
    }
    
    var mediaMessagesRef: FIRDatabaseReference{
        return dbRef.child("media_messages")
    }
    
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference(forURL:"gs://study-sesh-csc690.appspot.com")
    }
    
    var imageStorageRef:FIRStorageReference{
        return storageRef.child("image")
    }
    
    var videoStorageRef:FIRStorageReference{
        return storageRef.child("video")
    }
    
    func saveUser(withID:String,email:String,password:String){
        let data: Dictionary<String,Any> = ["email":email,"password":password];
        userRef.child(withID).setValue(data);
    }
    
    func saveSesh(withID:String,loc:String,time:String,course:String){
        
        
        let data: Dictionary<String,Any> = ["location":loc,"time":time,"course":course];
        seshsRef.child(withID).setValue(data);
    }
    
    func getContacts(){
        var con = [Contact]();
        seshsRef.observeSingleEvent(of: FIRDataEventType.value){
            (snapshot:FIRDataSnapshot) in
            if let myContacts = snapshot.value as? NSDictionary{
                for (key,value) in myContacts{
                    if let contactData = value as? NSDictionary{
                        if let email = contactData["location"] as? String{
                            if let time = contactData["time"] as? String{
                                if let course = contactData["course"] as? String{
                                    let id = key as! String;
                            
                                    let newContact = Contact(id: id, name:email,time:time,course:course);
                            con.append(newContact)
                                }
                            }
                        }
                    }
                }
            self.delegate?.dataReceived(contacts: con)
        }
    }
}
}
