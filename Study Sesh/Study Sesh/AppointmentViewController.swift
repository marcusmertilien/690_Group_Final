//
//  ViewController.swift
//  Study Sesh
//
//  Created by Marcus Mertilien on 4/16/18.
//  Copyright © 2018 Mertilien Studios. All rights reserved.
//

import UIKit

class AppointmentViewController: UITableViewController {
    
    var seshs = [studySesh]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//Table Cells
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3    //This value will change pending on how many elements are read from database. i.e list.count from marcus' TODO App
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{//Writes data to each cell from seshs
        let cellID = "seshCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SeshCell else{
            fatalError("The Dequed cell is not an instance of taskCell.")
        }
     
        return cell
    }
    
    
    
    //Temporary Test Data
    private func loadSampleTasks(){
        let sesh1 = studySesh(location: "Lib", time: "3pm")
        let sesh2 = studySesh(location: "Student Union", time: "12pm")
        let sesh3 = studySesh(location: "CS Lab", time: "8am")
        
        
        seshs.append(sesh1!)
        seshs.append(sesh2!)
        seshs.append(sesh3!)
        
    }
    
}

