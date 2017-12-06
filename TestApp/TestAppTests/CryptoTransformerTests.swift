//
//  TestAppTests.swift
//  TestAppTests
//
//  Created by Yaroslav Vorontsov on 04.12.2017.
//  Copyright © 2017 Yaroslav Vorontsov. All rights reserved.
//

import XCTest
@testable import TestApp

class CryptoTransformerTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        ValueTransformer.setValueTransformer(EncryptionValueTransformer(encryptionKey: "mysupersecretkey"), forName: NSValueTransformerName(rawValue: "Crypto1"))
        ValueTransformer.setValueTransformer(EncryptionValueTransformer(password: "secret-trololo", salt: "salty-salt"), forName: NSValueTransformerName(rawValue: "Crypto2"))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTransformer1() {
        guard let cryptoTransformer = ValueTransformer(forName: NSValueTransformerName(rawValue: "Crypto1")) else {
            XCTFail("Failed to get a registered transformer")
            return
        }

        guard let encrypted = cryptoTransformer.transformedValue("123456") else {
            XCTFail("Encryption test 1 failed!")
            return
        }
        print("Encrypted value: \(encrypted)")
        if let decrypted = cryptoTransformer.reverseTransformedValue(encrypted) as? String {
            print("Decrypted value: \(decrypted)")
            XCTAssert(decrypted == "123456")
        } else {
            XCTFail("Decryption test 1 failed")
        }
    }
    
    func testTransformer2() {
        guard let cryptoTransformer = ValueTransformer(forName: NSValueTransformerName(rawValue: "Crypto1")) else {
            XCTFail("Failed to get a registered transformer")
            return
        }

        guard let encrypted = cryptoTransformer.transformedValue("PBKDF2 is a cool function!") else {
            XCTFail("Encryption test 1 failed!")
            return
        }
        print("Encrypted value: \(encrypted)")
        if let decrypted = cryptoTransformer.reverseTransformedValue(encrypted) as? String {
            print("Decrypted value: \(decrypted)")
            XCTAssert(decrypted == "PBKDF2 is a cool function!")
        } else {
            XCTFail("Decryption test 2 failed")
        }
    }
    
}
