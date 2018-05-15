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

class MessageViewController: JSQMessagesViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    private var messages = [JSQMessage]();
    let choice = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choice.delegate = self
        
        let userID = FIRAuth.auth()?.currentUser!.uid
        let email = FIRAuth.auth()?.currentUser!.email
        self.senderId = userID
        self.senderDisplayName = email
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt
        indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        //let message = messages[indexPath.item]
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
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
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        collectionView.reloadData()
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pic = info[UIImagePickerControllerOriginalImage] as?
            UIImage{
            let picJSQ = JSQPhotoMediaItem(image:pic);
            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: picJSQ))
        
        }else if let vid = info[UIImagePickerControllerMediaURL] as? URL{
            let vidJSQ = JSQVideoMediaItem(fileURL: vid, isReadyToPlay:true)
            messages.append(JSQMessage(senderId:senderId, displayName:senderDisplayName,media:vidJSQ))
        }
        self.dismiss(animated:true,completion: nil)
        collectionView.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    

}
