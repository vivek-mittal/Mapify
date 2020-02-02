//
//  NetworkManager.swift
//  Mapify
//
//  Created by Vivek on 29/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    static let LOGIN_URL =          "https://onthemap-api.udacity.com/v1/session"
    static let LOCATION_URL =       "https://onthemap-api.udacity.com/v1/StudentLocation"
    static let SIGN_UP_URL =        "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
    
    static let HEADER_ACCEPT = "Accept"
    static let HEADER_CONTENT_TYPE = "Content-Type"
    static let APP_JSON = "application/json"
    
    func login(email: String, password: String, onComplete: @escaping (Errors?) -> Void) {
        
        var request = URLRequest(url: URL(string: NetworkManager.LOGIN_URL)!)
        request.httpMethod = HttpMethod.post.type()
        request.addValue(NetworkManager.APP_JSON, forHTTPHeaderField: NetworkManager.HEADER_ACCEPT)
        request.addValue(NetworkManager.APP_JSON, forHTTPHeaderField: NetworkManager.HEADER_CONTENT_TYPE)
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                self.handleError(error: error, onComplete: onComplete)
                return
            }
            let newData = self.stripSecurityCode(data)
            do {
                let loginResult = try JSONDecoder().decode(LoginResult.self, from: newData!)
                if loginResult.isLoginSuccessful() {
                    ModelManager.shared.loginResult = loginResult
                    print(loginResult)
                    onComplete(nil)
                } else {
                    self.handleResponseError(loginResult.status, onComplete: onComplete)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func logout(onComplete: @escaping (Errors?) -> Void) {
        
        var request = URLRequest(url: URL(string: NetworkManager.LOGIN_URL)!)
        request.httpMethod = HttpMethod.delete.type()
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                self.handleError(error: error, onComplete: onComplete)
                return
            }
            _ = self.stripSecurityCode(data)
            ModelManager.shared.loginResult = nil
            onComplete(nil)
        }
        task.resume()
    }
    
    func loadMapData(forceRefresh: Bool, onComplete: @escaping (Errors?) -> Void) {
        if !forceRefresh && ModelManager.shared.studentLocations != nil {
            onComplete(nil)
            return
        }
        
        var request = URLRequest(url: URL(string: NetworkManager.LOCATION_URL)!)
        request.httpMethod = HttpMethod.get.type()
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                self.handleError(error: error, onComplete: onComplete)
                return
            }
            do {
                let locationResult = try JSONDecoder().decode(LocationResult.self, from: data!)
                if locationResult.hasLocationData() {
                    ModelManager.shared.studentLocations = locationResult.results
                    onComplete(nil)
                } else {
                    onComplete(Errors.kDataNotAvailable)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func addLocation(address: String, url: String, latitude: Double, longitude: Double, onComplete: @escaping (Errors?) -> Void) {
        var request = URLRequest(url: URL(string: NetworkManager.LOCATION_URL)!)
        request.httpMethod = HttpMethod.post.type()
        request.addValue(NetworkManager.APP_JSON, forHTTPHeaderField: NetworkManager.HEADER_CONTENT_TYPE)
        request.httpBody = "{\"uniqueKey\": \"\((ModelManager.shared.loginResult?.account?.key)!)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                onComplete(Errors.kErrorAddingLocation)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            do {
                let addLocationResult = try JSONDecoder().decode(AddLocationResult.self, from: data!)
                if addLocationResult.code != nil {
                    onComplete(Errors.kErrorAddingLocation)
                } else {
                    onComplete(nil)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func handleResponseError(_ errorCode: Int?, onComplete: @escaping (Errors?) -> Void) {
        switch errorCode {
        case 400:
            onComplete(Errors.kCredentialMissing)
        case 401, 402, 403:
            onComplete(Errors.kInvalidCredential)
        default:
            onComplete(Errors.kUnknown)
        }
        
    }
    func stripSecurityCode(_ data: Data?) -> Data? {
        if data == nil || data!.count <= 5 {
            return nil
        }
        let newData = data?.subdata(in: 5..<data!.count)
        let jsonString = String(data: newData!, encoding: .utf8)!
        print(jsonString)
        return newData
    }
    
    func handleError(error: Error!, onComplete: @escaping ((Errors?) -> Void)) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                onComplete(Errors.kNetworkProblem)
                break
            default:
                onComplete(Errors.kServerProblem)
            }
        }
        onComplete(Errors.kServerProblem)
    }
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        
        func type() -> String {
            return rawValue
        }
    }
    
}
