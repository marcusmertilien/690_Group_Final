//
//  MessagesHandler.swift
//  Study Sesh
//
//  Created by Shyran on 5/14/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

protocol MessageRecievedDelegate:class {
    func messageRecieved(senderID: String, senderName:String, text:String)
    func mediaRecieved(senderID: String, senderName:String, url:String)
}

class MessagesHandler{
    private static let _instance = MessagesHandler()
    private init(){}
    
    weak var delegate:MessageRecievedDelegate?
    
    static var Instance: MessagesHandler{
        return _instance
    }
    
    func sendMessage(senderID:String,senderName:String,text:String){
        let data: Dictionary<String,Any> = ["sender_id": senderID,"sender_name":senderName,"text":text];
        DBfirebase.Instance.chatRef.childByAutoId().setValue(data)
    }
    
    func sendMediaMessage(senderID:String,senderName:String,url:String){
        let data: Dictionary<String,Any> = ["sender_id":senderID,"sender_name":senderName,"url":url]
        
        DBfirebase.Instance.mediaMessagesRef.childByAutoId().setValue(data)
    }
    
    func sendMedia(image:Data?,video:URL?,senderID:String,senderName:String){
        if image != nil{ //send image
            DBfirebase.Instance.imageStorageRef.child(senderID + "\(NSUUID().uuidString).jpg").put(image!,metadata:nil){
                (metadata:FIRStorageMetadata?,err:Error?) in
                if err != nil{
                    //upload image error
                }else{
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
                }
            }
        }else{ //send video
            DBfirebase.Instance.videoStorageRef.child(senderID + "\(NSUUID().uuidString)").putFile(video!,metadata:nil){
                (metadata:FIRStorageMetadata?,err:Error?) in
                
                if err != nil{
                    //upload video error
                }else{
                    self.sendMediaMessage(senderID: senderID, senderName: senderName,url:String(describing: metadata!.downloadURL()!))
                }
            }
        }
    }
    
    func observeMessages(){
        DBfirebase.Instance.chatRef.observe(FIRDataEventType.childAdded){
            (snapshot:FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary{
                if let senderID = data["sender_id"] as?
                String{
                    if let senderName = data["sender_name"] as? String{
                        if let text = data["text"] as? String{
                            self.delegate?.messageRecieved(senderID: senderID, senderName: senderName, text: text)
                        }
                    }
                    
                }
            }
        }
    }
    
    func obserMediaMessages(){
        DBfirebase.Instance.mediaMessagesRef.observe(FIRDataEventType.childAdded){
            (snapshot:FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary{
                if let id = data["sender_id"] as? String{
                    if let name = data["name"] as?
                        String{
                        if let fileURL = data["url"] as?
                            String{
                            self.delegate?.mediaRecieved(senderID:id, senderName:name, url:fileURL)
                        }
                    }
                }
            }
        }
    }
}
