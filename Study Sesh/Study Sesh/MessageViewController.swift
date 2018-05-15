//
//  MessageViewController.swift
//  Study Sesh
//
//  Created by Shyran on 5/14/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class MessageViewController: JSQMessagesViewController, MessageRecievedDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    
    private var messages = [JSQMessage]();
    let choice = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choice.delegate = self
        MessagesHandler.Instance.delegate = self
       
        let email = FIRAuth.auth()?.currentUser!.email
        self.senderId = FBAuth.Instance.userID()
        self.senderDisplayName = email
        // Do any additional setup after loading the view.
        
        MessagesHandler.Instance.observeMessages()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt
        indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        //let message = messages[indexPath.item]
        let message = messages[indexPath.item]
        if message.senderId == self.senderId{
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        }else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.green)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! { 
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"profile"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messages[indexPath.item]
        if msg.isMediaMessage{
            if let mediaItem = msg.media as? JSQVideoMediaItem{
                let player = AVPlayer(url:mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true,completion: nil)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title:"Media Messages",message:"Please choose a Media",preferredStyle: .actionSheet);
        let cancel = UIAlertAction(title:"Cancel",style:.cancel,handler:nil)
        let photos = UIAlertAction(title:"Photos",style: .default,handler:{(alert:UIAlertAction) in
            self.mediaChoice(type: kUTTypeImage)
        })
        let videos = UIAlertAction(title:"Videos",style: .default,handler:{(alert:UIAlertAction) in
            self.mediaChoice(type: kUTTypeMovie)
        })
        alert.addAction(photos)
        alert.addAction(cancel)
        alert.addAction(videos)
        present(alert,animated:true,completion:nil)
    }
    
    private func mediaChoice(type:CFString){
        choice.mediaTypes = [type as String]
        present(choice,animated:true,completion:nil);
    }
    
    //pick media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pic = info[UIImagePickerControllerOriginalImage] as?
            UIImage{
            let data = UIImageJPEGRepresentation(pic, 0.01)
            MessagesHandler.Instance.sendMedia(image: data, video: nil, senderID: senderId, senderName: senderDisplayName)
        }else if let vid = info[UIImagePickerControllerMediaURL] as? URL{
            MessagesHandler.Instance.sendMedia(image: nil, video: vid, senderID: senderId, senderName: senderDisplayName)
        }
        self.dismiss(animated:true,completion: nil)
        collectionView.reloadData()
    }
    
    //read messages
    func messageRecieved(senderID: String,senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, text:text))
        collectionView.reloadData()
    }
    
    func mediaRecieved(senderID: String,senderName: String, url: String) {
        if let mediaURL = URL(string:url){
            do{
                let data = try Data(contentsOf:mediaURL)
                    if let _ = UIImage(data:data){
                    let _ = SDWebImageDownloader.shared().downloadImage(with:mediaURL,options:[],progress:nil,completed:{
                        (image,data,error,finished) in
                        
                        DispatchQueue.main.async{
                            let photo = JSQPhotoMediaItem(image:image)
                            if senderID == self.senderId{
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            }else{
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            self.messages.append(JSQMessage(senderId:senderID,displayName:senderName,media:photo))
                                self.collectionView.reloadData()
                        }
                    })
                    }else{
                        let video = JSQVideoMediaItem(fileURL:mediaURL,isReadyToPlay:true)
                        if senderID == self.senderId{
                            video?.appliesMediaViewMaskAsOutgoing=true
                        }else{
                            video?.appliesMediaViewMaskAsOutgoing=false
                        }
                        messages.append(JSQMessage(senderId:senderID,displayName:senderName,media:video))
                        self.collectionView.reloadData()
                }
            }catch{
                //catch error
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
