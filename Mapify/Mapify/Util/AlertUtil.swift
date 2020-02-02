//
//  AlertUtil.swift
//  Mapify
//
//  Created by Vivek on 01/02/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import UIKit

class AlertUtil {
    private init() { }
    
    static func showAlert(message: String, onViewController: UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("dismiss")
        }))
    onViewController.present(alert, animated: true, completion: nil)
    }
}
