//
//  APIClient.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 06/01/2021.
//

import Foundation

enum WebserviceError: Error {
    case DataEmptyError
    case ResponseError
}

class APIClient {

    lazy var session: ToDoURLSession = URLSession.shared
    var keychainManager: KeychainAccessible?

    func loginUserWithName(
        username: String,
        password: String,
        completion: (Error?) -> Void) {
        
        let allowedCharacters = NSCharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        guard let encodedUsername = username.addingPercentEncoding(
            withAllowedCharacters: allowedCharacters
        ) else {
            fatalError()
        }
        
        guard let encodedPassword = password.addingPercentEncoding(
            withAllowedCharacters: allowedCharacters
        ) else {
            fatalError()
        }
        
        guard let url = URL(
            string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)"
        ) else {
            fatalError()
        }
        
//        session.dataTaskWithURL(url: url) { (data, response, error) -> Void in
//            
//            if error != nil {
//                completion(WebserviceError.ResponseError)
//                return
//            }
//
//            if let theData = data {
//                do {
//                    let responseDict = try JSONSerialization.jsonObject(
//                        with: data!,
//                        options: []
//                    ) as! [String: String]
//                    
//                    let token = responseDict["token"] as! String
//                    self.keychainManager?.setPassword(
//                        password: token,
//                        account: "token"
//                    )
//                } catch {
//                    completion(error)
//                }
//            } else {
//                completion(WebserviceError.DataEmptyError)
//            }
//        }.resume()

    }




    
}

protocol ToDoURLSession {

    func dataTaskWithURL(
        url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask

}

extension URLSession: ToDoURLSession {

    func dataTaskWithURL(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url, completionHandler: completionHandler)
    }

}
