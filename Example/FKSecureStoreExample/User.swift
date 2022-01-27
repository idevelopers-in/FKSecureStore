//
//  User.swift
//  FKSecureStoreExample
//
//  Created by Firoz Khan on 27/01/22.
//

import Foundation

class User: NSObject, NSSecureCoding {
    
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    //MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObject(forKey: "username") as! String
        self.password = aDecoder.decodeObject(forKey: "password") as! String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(password, forKey: "password")
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
}
