//
//  FBAuth.swift
//  Study Sesh
//
//  Created by Shyran on 5/14/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FBAuth{
    private static let _instance = FBAuth()
    
    static var Instance: FBAuth{
        return _instance
    }
    
    var userName=""
    
    func userID() -> String{
        return FIRAuth.auth()!.currentUser!.uid
    }
    
}
