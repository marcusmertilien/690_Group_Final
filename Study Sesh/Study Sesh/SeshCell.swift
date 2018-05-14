//
//  SeshCell.swift
//  Study Sesh
//
//  Created by Marcus Mertilien on 4/18/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit

class SeshCell: UITableViewCell{
    
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Time: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
