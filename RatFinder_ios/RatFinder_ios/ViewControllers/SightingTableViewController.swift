//
//  SightingTableViewController.swift
//  RatFinder_ios
//
//  Created by William Lim on 10/15/17.
//  Copyright © 2017 Kedar Rao. All rights reserved.
//
import UIKit
import Firebase

class SightingTableViewController: UITableViewController {
    
    //MARK: Properties
    var sightingsList = [Sighting]()
    var refRats: DatabaseReference!
    
    //Mark: Private Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refRats = Database.database().reference()
        //Fetch values from FireBase
        refRats.observe(DataEventType.value, with: { (snapshot) in

            //if the reference have some values
            if snapshot.childrenCount > 0 {

                //clearing the list
                self.sightingsList.removeAll()

                //iterating through all the values
                for ratSighting in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let ratObject = ratSighting.value as? [String: AnyObject]
                    let createdDate = ratObject?["Created Date"]
                    let incidentAddress  = ratObject?["Incident Address"]

                    //creating sighting object with model and fetched valu
                   let sighting = Sighting(createdDate: createdDate as! String?, incidentAddress: incidentAddress as! String?)
                    //appending it to list
                    self.sightingsList.append(sighting)
                }

                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sightingsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SightingTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SightingTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SightingTableViewCell.")
        }
        
        //getting the sighting of selected position
        let sighting = sightingsList[indexPath.row]
        //adding values to labels
        cell.createdDate.text = sighting.createdDate
        cell.incidentAddress.text = sighting.incidentAddress
    
        return cell
    }

}
