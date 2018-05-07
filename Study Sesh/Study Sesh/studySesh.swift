//
//  studySesh.swift
//  Study Sesh
//
//  Created by Marcus Mertilien on 4/18/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit
import os.log


class studySesh: NSObject,NSCoding{
    
    var sesh: studySesh?
    
    struct PropertyKey{
        static let location = "text"
        static let time = "text"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
            else{
                os_log("Unable to decode the info for a task object", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
            else{
                os_log("Unable to decode the info for a task object", log: OSLog.default, type: .debug)
                return nil
        }
        self.init(location:location, time:time)
    }
    var location: String?
    var time: String?
    
    //Initializer
    init?(location: String, time: String){
        self.location = location
        self.time = time
    }
    
    //Optional empty initializer
    override init(){
        self.location = ""
        self.time = ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(time, forKey: PropertyKey.time)
    }
    
    //Mark: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("seshs")
}
