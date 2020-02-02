//
//  Error.swift
//  Mapify
//
//  Created by Vivek on 30/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import Foundation

public enum Errors: String {
    case kInvalidCredential = "Invalid username or password."
    case kCredentialMissing = "Bad request, username or password missing."
    case kCredentialExpired = "Credentials expired. Please login again."
    case kNetworkProblem = "Please check your network and try again."
    case kServerProblem = "Server problem. Please contact your support team."
    case kUnknown = "Something unknown happened. Please contact your support team."
    case kDataNotAvailable = "Data not available."
    case kErrorAddingLocation = "Some error happened trying to add location."
}
