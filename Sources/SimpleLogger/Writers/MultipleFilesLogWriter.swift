//
//  MultipleFilesLogWriter.swift
//  SimpleLogger
//
//  Created by Boyan Yankov on W07 17/Feb/2019 Sun.
//

import Foundation

struct MultipleFilesLogWriter {
    
    // MARK: - Properties
    fileprivate static var logsDirectoryPath: String = ""
    static func update_logsDirectoryPath(_ newValue: String) {
        MultipleFilesLogWriter.logsDirectoryPath = newValue
        guard MultipleFilesLogWriter.logsDirectoryPath.count > 0 else {
            return
        }
        MultipleFilesLogWriter.createLogsDirectory(at: self.logsDirectoryPath)
    }
    
    /// We should have only one logs directory.
    fileprivate static var didCreateLogsDirectory: Bool = false
    
    // MARK: - Initialization
    fileprivate init() {}
    
    // MARK: - Utils
    static func write(_ candidate: String,
                      toFileAtPath path: String)
    {
        guard MultipleFilesLogWriter.didCreateLogsDirectory else {
            let message: String = "Logs directory not available"
            print(message)
            return
        }

        WriterUtils.write(candidate, toFileAtPath: path)
    }
    
    fileprivate static func createLogsDirectory(at path: String) {
        guard !MultipleFilesLogWriter.didCreateLogsDirectory else {
            return
        }
        self.didCreateLogsDirectory = WriterUtils.createDirectory(at: path)
    }
}
