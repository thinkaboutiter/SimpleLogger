//
//  MultipleFilesLogWriter.swift
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

struct MultipleFilesLogWriter {
    
    // MARK: - Properties
    private static var logsDirectoryPath: String = ""
    static func setLogsDirectoryPath(_ newValue: String) {
        MultipleFilesLogWriter.logsDirectoryPath = newValue
        guard MultipleFilesLogWriter.logsDirectoryPath.count > 0 else {
            return
        }
        MultipleFilesLogWriter.createLogsDirectory(at: self.logsDirectoryPath)
    }
    
    /// We should have only one logs directory.
    private static var didCreateLogsDirectory: Bool = false
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Utils
    static func write(_ candidate: String,
                      toFile fileName: String) throws
    {
        guard MultipleFilesLogWriter.didCreateLogsDirectory else {
            let message: String = "Logs directory not available"
            print(message)
            throw Error.writeToFile(reason: message)
        }
        let path_candidate: String = "\(MultipleFilesLogWriter.logsDirectoryPath)/\(fileName)\(Constants.logFileExtension)"
        guard let valid_absolutePath: String = WriterUtils.absoulutePathString(from: path_candidate) else {
            let message: String = "Invalid log file path!"
            print(message)
            throw Error.writeToFile(reason: message)
        }
        try WriterUtils.write(candidate, toFileAtPath: valid_absolutePath)
    }
    
    private static func createLogsDirectory(at path: String) {
        guard !MultipleFilesLogWriter.didCreateLogsDirectory else {
            return
        }
        self.didCreateLogsDirectory = WriterUtils.createDirectory(at: path)
    }
}

// MARK: - Constants
extension MultipleFilesLogWriter {
    
    private enum Constants {
        static let logFileExtension: String = ".log"
    }
}

// MARK: - Error
extension MultipleFilesLogWriter {
    
    enum Error: Swift.Error {
        case writeToFile(reason: String)
    }
}
