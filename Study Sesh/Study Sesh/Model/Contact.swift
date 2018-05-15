//
//  Contact.swift
//  Study Sesh
//
//  Created by Shyran on 5/13/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation

class Contact{
    
    init(id:String,name:String,time:String){
        _id = id;
        _name = name;
        _time = time;
      
    }
    private var _name = "";
    private var _id = "";
    private var _time = "";

    
    var name:String{
        return _name;
    }
    var id:String{
        return _id;
    }
    
    var time:String{
        return _time;
    }
}
