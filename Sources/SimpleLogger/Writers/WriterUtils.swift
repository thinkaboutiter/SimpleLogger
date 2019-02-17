//
//  WriterUtils.swift
//  SimpleLogger
//
//  Created by Boyan Yankov on W07 17/Feb/2019 Sun.
//

import Foundation

/// Helper type for file IO.
struct WriterUtils {
    
    static func directoryPath(from candidate: String) -> String? {
        guard let valid_url = URL(string: candidate) else {
            return nil
        }
        let pathComponents: [String] = valid_url.pathComponents
        let folderPath: String
        let fm = FileManager.default
        if fm.fileExists(atPath: valid_url.absoluteString) {
            folderPath = "/\(pathComponents[1..<pathComponents.count-1].joined(separator: "/"))"
        }
        else {
            folderPath = "/\(pathComponents[1..<pathComponents.count].joined(separator: "/"))"
        }
        return folderPath
    }
    
    static func createDirectory(at path: String) -> Bool {
        let fm: FileManager = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
                return true
            }
            catch {
                print("error:\(error)")
                return false
            }
        }
        else {
            return true
        }
    }
    
    static func write(_ candidate: String,
                      toFileAtPath path: String)
    {
        let fm = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                print("error:\(error)")
            }
        }
        guard fm.isWritableFile(atPath: path) else {
            return
        }
        guard let valid_fileHandle = FileHandle(forWritingAtPath: path) else {
            let message: String = "Unable to obtain valid \(String(describing: FileHandle.self)) object!"
            print(message)
            return
        }
        let stringToWrite = "\(candidate)\n"
        valid_fileHandle.seekToEndOfFile()
        
        guard let valid_data: Data = stringToWrite.data(using: String.Encoding.utf8) else {
            let message: String = "Unable to obtain valid \(String(describing: Data.self)) object from candidate=\(stringToWrite)!"
            print(message)
            return
        }
        valid_fileHandle.write(valid_data)
        valid_fileHandle.closeFile()
    }
    
    static func removeFile(at path: String) {
        let fm = FileManager.default
        guard fm.fileExists(atPath: path) else {
            return
        }
        do {
            try fm.removeItem(atPath: path)
        }
        catch {
            print("error:\(error)")
        }
    }
    
    static func fileSize(at path: String) -> UInt64 {
        let fm: FileManager = FileManager.default
        guard fm.fileExists(atPath: path) else {
            return 0
        }
        guard let valid_attributes: [FileAttributeKey: Any] = try? fm.attributesOfItem(atPath: path) else {
            return 0
        }
        guard let valid_fileSize: UInt64 = valid_attributes[FileAttributeKey.size] as? UInt64 else {
            return 0
        }
        return valid_fileSize
    }
}
