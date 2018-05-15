//
//  Contact.swift
//  Study Sesh
//
//  Created by Shyran on 5/13/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation

class Contact{
    
    init(id:String,name:String,time:String, course:String){
        _id = id;
        _name = name;
        _time = time;
        _course = course;
    }
    
    private var _name = "";
    private var _id = "";
    private var _time = "";
    private var _course = ""
    
    var name:String{
        return _name;
    }
    
    var id:String{
        return _id;
    }
    
    var time:String{
        return _time;
    }
    
    var course:String{
        return _course;
    }
}
