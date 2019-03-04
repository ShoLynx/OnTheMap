//
//  AppClient.swift
//  OnTheMap
//
//  Created by Administrator on 1/7/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class AppClient {
    
    //MARK: API keys and contact URLs
    
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    enum Endpoints {
        static let base = "https://parse.udacity.com/parse/classes"
        static let udacityBase = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocation
        case login
        case uploadData
        case getUserData
        
        var stringValue: String {
            switch self {
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .login: return Endpoints.udacityBase + "/session"
            case .uploadData: return Endpoints.base + "/StudentLocation"
            case .getUserData: return Endpoints.udacityBase + "/users/\(Auth.key)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    
    //MARK: Stored values
    
    struct Auth {
        static var key = ""
        static var sessionId = ""
    }
    
    struct UserInfo {
        static var createdAt = ""
        static var objectId = ""
        static var uniqueKey = ""
        static var firstName = ""
        static var lastName = ""
        static var mapString = ""
        static var mediaURL = ""
        static var latitude: Double?
        static var longitude: Double?
        static var updatedAt = ""
    }
    
    
    //MARK: Global functions
    
    //Gets 100 Student Location objects from Parse and stores them into the MapPool.results struct in SearchResults.
    
    class func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocation.url)
        request.httpMethod = "GET"
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(SearchResults.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                    MapPool.results = responseObject.results
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(ParseResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    //Posts users' Username and Password input to Udacity.  If authentication is successful, the received account key and session ID are stored in the AppClient.Auth struct.
    
    class func login(nametext: String, passtext: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        let body = LoginRequest(udacity: Udacity(username: nametext, password: passtext))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        print(String(data: request.httpBody!, encoding: .utf8)!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try JSONDecoder().decode(LoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(true, nil)
                    print(String(data: newData, encoding: .utf8)!)
                    Auth.key = responseObject.account.key
                    Auth.sessionId = responseObject.session.id
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(UResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    //Makes a call to Udacity to delete session information.
    
    class func logout (completion: @escaping() -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.key = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    //Posts users' StudentLocation information to Parse.  If successful, the received createdAt and objectId values are stored in the AppClient.UserInfo struct.
    
    class func uploadInfo (completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.uploadData.url)
        let body = StudentLocation(firstName: AppClient.UserInfo.firstName, lastName: AppClient.UserInfo.lastName, latitude: AppClient.UserInfo.latitude, longitude: AppClient.UserInfo.longitude, mapString: AppClient.UserInfo.mapString, mediaURL: AppClient.UserInfo.mediaURL, uniqueKey: AppClient.UserInfo.uniqueKey)
        request.httpMethod = "POST"
        request.addValue(self.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(PostResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(true, nil)
                    AppClient.UserInfo.createdAt = responseObject.createdAt
                    AppClient.UserInfo.objectId = responseObject.objectId
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(ParseResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    //Gets users' current information from Parse.  If successful, users' first name, last name and unique key are stored in AppClient.UserInfo.
    
    class func getUserInfo (completion: @escaping (FromParse?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getUserData.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try JSONDecoder().decode(FromParse.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    AppClient.UserInfo.firstName = responseObject.firstName ?? ""
                    AppClient.UserInfo.lastName = responseObject.lastName ?? ""
                    AppClient.UserInfo.uniqueKey = responseObject.uniqueKey ?? ""
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                    print(error)
                }
            }
        }
        task.resume()
    }
}
