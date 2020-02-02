//
//  LoginResult.swift
//  Mapify
//
//  Created by Vivek on 29/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import Foundation

class LoginResult: Codable {
    var account: Account?
    var session: Session?
    var status: Int?
    var error: String?
}

class Account: Codable {
    var registered: Bool?
    var key: String?
}

class Session: Codable {
    var id: String?
    var expiration: String?
}

extension LoginResult {
    func isLoginSuccessful() -> Bool {
        return account != nil && session != nil
    }
}

