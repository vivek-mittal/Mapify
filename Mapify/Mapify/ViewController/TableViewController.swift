//
//  TableViewController.swift
//  Mapify
//
//  Created by Vivek on 30/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sortedStudentLocations: [StudentInformation]? = nil

    let kTableViewCellID = "tableview_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.loadMapData(forceRefresh: false) { (error) in
            self.sortedStudentLocations = ModelManager.shared.studentLocations
            self.sortedStudentLocations?.sort {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date1 = dateFormatter.date(from:$0.updatedAt!)
                let date2 = dateFormatter.date(from:$1.updatedAt!)
                return date1!.compare(date2!) == .orderedAscending
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        NetworkManager.shared.loadMapData(forceRefresh: true) { (error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addLocation = self.storyboard!.instantiateViewController(withIdentifier: "add_location")
        self.present(addLocation, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        NetworkManager.shared.logout { (error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.showLoginScreen()
                }
            })
        }
    }
    
    func showLoginScreen() {
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        sceneDelegate.showLoginScreen()
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedStudentLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellID)
        cell?.textLabel?.text = self.sortedStudentLocations![indexPath.row].getName()
        cell?.detailTextLabel?.text = self.sortedStudentLocations?[indexPath.row].mediaURL
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaUrl = self.sortedStudentLocations![indexPath.row].mediaURL
        if let link = URL(string: mediaUrl ?? "") {
            UIApplication.shared.open(link)
        }
    }
}
