//
//  KeychainItem.swift
//  CarmatecTask
//
//  Created by Jayantkarthic on 08/05/24.
//

import Foundation

struct KeychainItem {
    
    // MARK: Types
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    
    // MARK: Properties
    let service: String
    let accessGroup: String?
    private(set) var account: String
    
    // MARK: Intialization
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain access
    func readItem() throws -> String {
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func saveItem(_ password: String) throws {
        
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            try _ = readItem()
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func deleteItem() throws {
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    // MARK: Convenience
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}

//Mark - Helper
extension KeychainItem {
    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "com.developerinsider.SignInWithAppleDemo"
    }
    
    static var currentUserIdentifier: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userIdentifier").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userIdentifier").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userIdentifier").saveItem(value)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
        }
    }
    
    static var currentUserFirstName: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userFirstName").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userFirstName").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userFirstName").saveItem(value)
            } catch {
                print("Unable to save userFirstName to keychain.")
            }
        }
    }
    
    static var currentUserLastName: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userLastName").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userLastName").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userLastName").saveItem(value)
            } catch {
                print("Unable to save userLastName to keychain.")
            }
        }
    }
    
    static var currentUserEmail: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userEmail").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userEmail").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userEmail").saveItem(value)
            } catch {
                print("Unable to save userEmail to keychain.")
            }
        }
    }
}
