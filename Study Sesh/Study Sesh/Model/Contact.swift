//
//  Contact.swift
//  Study Sesh
//
//  Created by Shyran on 5/13/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import Foundation

class Contact{
    
    init(id:String,name:String){
        _id = id;
        _name = name;
    }
    private var _name = "";
    private var _id = "";
    
    var name:String{
        return _name;
    }
    var id:String{
        return _name;
    }
}
