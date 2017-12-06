//
//  EncryptionValueTransformer.swift
//  TestApp
//
//  Created by Yaroslav Vorontsov on 29.11.2017.
//  Copyright © 2017 Yaroslav Vorontsov. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto

// Example 2: value transformation
// Based on https://github.com/iosdevzone/IDZSwiftCommonCrypto

public class EncryptionValueTransformer: ValueTransformer {
    
    private enum Constants {
        static let blockSize = 16
        static let keyLength: UInt = 16
        static let roundCount: uint = 10000
    }
    
    private let key: [UInt8]
    
    init(encryptionKey: String) {
        key = arrayFrom(string: encryptionKey)
    }
    
    init(password: String, salt: String) {
        key = PBKDF.deriveKey(password: password, salt: salt, prf: .sha256, rounds: Constants.roundCount, derivedKeyLength: Constants.keyLength)
    }
    
    override open class func transformedValueClass() -> Swift.AnyClass {
        return NSString.self
    }
    
    override open class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override open func transformedValue(_ value: Any?) -> Any? {
        guard let plainText = value as? NSString else {
            print("No transformation applied, returning nil")
            return nil
        }
        var data = Data(count: Constants.blockSize)
        let code = data.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, data.count, $0)  }
        guard code == errSecSuccess else {
            print("Failed to grab IV, failing")
            return nil
        }
        let iv = [UInt8](data)
        let cryptor = Cryptor(operation: .encrypt, algorithm: .aes, options: .PKCS7Padding, key: key, iv: iv)
        guard let cipherText = cryptor.update(string: plainText as String)?.final() else {
            print("Encryption failed with status \(cryptor.status)")
            return nil
        }
        return NSString(string: "AES128-CBC:\(hexString(fromArray:iv)):\(hexString(fromArray: cipherText))")
    }
    
    override open func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let fullText = value as? NSString else {
            print("No transformation applied, returning nil")
            return nil
        }
        let cryptoData = fullText.components(separatedBy: ":")[1...]
        // Skip algo selection via parts.first
        guard let ivText = cryptoData.first, let cipherText = cryptoData.last else {
            print("Failed to extract algorithm, IV and crypto data, returning nil")
            return nil
        }
        let iv = arrayFrom(hexString: ivText)
        let decryptor = Cryptor(operation: .decrypt, algorithm: .aes, options: .PKCS7Padding, key: key, iv: iv)
        guard let plainText = decryptor.update(byteArray: arrayFrom(hexString: cipherText))?.final() else {
            print("Decryption failed with status \(decryptor.status)")
            return nil
        }
        return String(bytes: plainText, encoding: .utf8)
    }
}
