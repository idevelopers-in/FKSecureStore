//
// FKSecureStore.swift
//
// Copyright (c) 2020 Firoz Khan
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Security

private let kSecureKeyPrefix = Bundle.main.bundleIdentifier! + ".FKSecureStore."

@objc public class FKSecureStore: NSObject
{
    @objc public enum Status: Int
    {
        case success
        case noData
        case other
        
        // https://www.osstatus.com
        init(from: OSStatus) {
            
            if from == noErr {
                self = .success
            }
            else if from == -25300 {
                self = .noData
            }
            else {
                self = .other
            }
        }
    }
    
    private class func privateKey(key: String) -> String {
        return "\(kSecureKeyPrefix)\(key)"
    }
    
    // MARK: - Save Functions
    
    /**
     Save any `String` for a particular key inside the keychain.
     
     - Parameters:
     - string: The string to be saved.
     - key: The key for which the string should be saved.
     
     - Returns: An enum containing the status of the operation.
     */
    @discardableResult
    @objc public class func save(string: String, key: String) -> Status {
        
        if let stringData = string.data(using: .utf8, allowLossyConversion: false) {
            return save(data: stringData, key: key)
        }
        return Status.other
    }
    
    /**
     Save any `Data` for a particular key inside the keychain.
     
     - Parameters:
     - data: The data to be saved.
     - key:  The key for which the data should be saved.
     
     - Returns: An enum containing the status of the operation.
     */
    @discardableResult
    @objc public class func save(data: Data, key: String) -> Status {
        
        let query: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): privateKey(key: key),
            String(kSecValueData): data
        ]
        
        SecItemDelete(query as CFDictionary)
        var result: CFTypeRef? = nil
        let status = SecItemAdd(query as CFDictionary, &result)
        return Status(from: status)
    }
    
    // MARK: - Load Functions
    
    /**
     Retrieve any saved `String` for a particular key inside the keychain.
     
     - Parameter key: The key for which the `String` should be retrieved.
     
     - Returns: An optional `String` object.
     */
    @objc public class func load(key: String) -> String? {
        
        if let data = load(dataForKey: key){
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /**
     Retrieve any saved `Data` for a particular key inside the keychain.
     
     - Parameter key: The key for which the `Data` should be retrieved.
     
     - Returns: An optional `Data` object.
     */
    @objc public class func load(dataForKey key: String) -> Data? {
        
        let query = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): privateKey(key: key),
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        _ = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        return dataTypeRef as? Data
    }
    
    // MARK: - Clear and Delete Functions
    
    /**
     Delete stored data for a particular key inside the keychain.
     
     - Parameter key: The key for which the data should be deleted.
     
     - Returns: An enum containing the status of the operation.
     */
    @discardableResult
    @objc public class func delete(key: String) -> Status {
        
        let query = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): privateKey(key: key)
        ] as [String : Any]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return Status(from: status)
    }
    
    /**
     Delete all stored app data inside the keychain.
     
     - Returns: An enum containing the status of the operation.
     */
    @discardableResult
    @objc public class func clear() -> Status {
        
        let query = [
            String(kSecClass): kSecClassKey,
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return Status(from: status)
    }
}
