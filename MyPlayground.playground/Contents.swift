//: Playground - noun: a place where people can play

import Foundation
import Security

// Demo 1: file protection

public func protectFile(_ file: String, in domain: FileManager.SearchPathDirectory) {
    let fileManager = FileManager()
    guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(domain, .userDomainMask, true).first else {
        print("No directory in domain \(domain.rawValue) available")
        return
    }
    let attributes = [
        FileAttributeKey.protectionKey: FileProtectionType.complete
    ]
    let path = NSString(string: documentsDirectory).appendingPathComponent(file)
    guard fileManager.fileExists(atPath: path) else {
        print("File does not exist at path \(path)")
        return
    }
    try? fileManager.setAttributes(attributes, ofItemAtPath: path)
}

protectFile("MyProfile.xml", in: .documentDirectory)
