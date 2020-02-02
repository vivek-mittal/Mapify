//
//  ViewController.swift
//  Mapify
//
//  Created by Vivek on 29/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func loginButtonTapped(_ view: UIView) {
        NetworkManager.shared.login(email: usernameField.text!, password: passwordField.text!, onComplete: {error in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.showHomeScreen()
                } else {
                    self.errorLabel.text = (error)!.rawValue
                }
            })
        })
    }
    
    func onLoginSuccess() {
        showHomeScreen()
    }
    
    func showHomeScreen() {
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        sceneDelegate.showHomeScreen()
    }
    
    @IBAction func signUpButtonTapped(_ view: UIView) {
        if let link = URL(string: NetworkManager.SIGN_UP_URL) {
            UIApplication.shared.open(link)
        }
    }
    
}

