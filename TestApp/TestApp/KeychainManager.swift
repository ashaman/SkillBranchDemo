//
//  KeychainManager.swift
//  TestApp
//
//  Created by Yaroslav Vorontsov on 04.12.2017.
//  Copyright © 2017 Yaroslav Vorontsov. All rights reserved.
//

import Foundation
import KeychainAccess

// Demo 3: Usage of Keychain
// Based on https://github.com/kishikawakatsumi/KeychainAccess

class KeychainManager {
    
    private enum Constants {
        static let defaultBundleID = "com.ashaman.defaultbundleid"
        static let service = "MyMailbox.biz"
        static let comment = "Default comment for an item"
        static let teamPrefix = "G5EG5T3U3L"
        static let authPrompt = "Authenticate to set up protection for your password item"
        static let dumpPrompt = "Authenticate to dump your keychain contents"
    }
    
    public init() {
        let bundleID = Bundle(for: KeychainManager.self).bundleIdentifier ?? Constants.defaultBundleID
        let accessGroup = [Constants.teamPrefix, bundleID].joined(separator: ".")
        keychain = Keychain(service: Constants.service, accessGroup: accessGroup)
    }
    
    private let keychain: Keychain
    
    public func savePassword(_ password: String, for key: String, with label: String) {
        do {
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                .authenticationPrompt(Constants.authPrompt)
                .comment(Constants.comment)
                .label(label)
                .set(password, key: key)
            print("Item has been successfully saved!")
        } catch (let error) {
            print("Failed to save password \(password) with label \(label): \(error)")
        }
    }
    
    public func dumpAllAttributes(for key: String) {
        do {
            let attributeDict = try keychain
                .authenticationPrompt(Constants.dumpPrompt)
                .get(key) { $0 }
            if let attributes = attributeDict {
                print("All attributes for value under key \(key): \(attributes)")
            }
        } catch (let error) {
            print("Failed to get attributes for item under key \(key): \(error)")
        }
    }
}

