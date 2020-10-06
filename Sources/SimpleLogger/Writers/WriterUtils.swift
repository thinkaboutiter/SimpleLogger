//
//  WriterUtils.swift
//  SimpleLogger
//
//  The MIT License (MIT)
//
//  Copyright (c) 2020 thinkaboutiter (thinkaboutiter@gmail.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
    
    static func absoulutePathString(from candidate: String) -> String? {
        guard let valid_url: URL = URL(string: candidate) else {
            return nil
        }
        return valid_url.absoluteString
    }
    
    static func write(_ candidate: String,
                      toFileAtPath path: String) throws
    {
        let fm = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                print("error:\(error)")
                return
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
    
    static func removeFile(at path: String) throws {
        let fm = FileManager.default
        guard fm.fileExists(atPath: path) else {
            let message: String = "File doesn't exit at path=\(path)"
            throw Error.removeFile(reason: message)
        }
        try fm.removeItem(atPath: path)
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

// MARK: - Errors
extension WriterUtils {
    
    enum Error: Swift.Error {
        case writeToFile(reason: String)
        case removeFile(reason: String)
    }
}
