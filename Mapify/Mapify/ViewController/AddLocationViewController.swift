//
//  AddLocationViewController.swift
//  Mapify
//
//  Created by Vivek on 31/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "show_map_location", sender: locationTextField.text!)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddLocationMapViewController
        destinationVC.address = sender as! String?
        destinationVC.link = urlTextField.text
     }
    
}
