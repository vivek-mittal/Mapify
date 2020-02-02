//
//  ModelManager.swift
//  Mapify
//
//  Created by Vivek on 01/02/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import Foundation

class ModelManager {
    static let shared = ModelManager()
    private init() { }

    var loginResult: LoginResult? = nil
    var studentLocations: [StudentInformation]? = nil

}
