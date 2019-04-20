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
    static func setLogsDirectoryPath(_ newValue: String) {
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
                      toFile fileName: String) throws
    {
        guard MultipleFilesLogWriter.didCreateLogsDirectory else {
            let message: String = "Logs directory not available"
            print(message)
            throw MultipleFilesLogWriterError.writeToFile(reason: message)
        }
        let path_candidate: String = "\(MultipleFilesLogWriter.logsDirectoryPath)/\(fileName)\(Constants.logFileExtension)"
        guard let valid_absolutePath: String = WriterUtils.absoulutePathString(from: path_candidate) else {
            let message: String = "Invalid log file path!"
            print(message)
            throw MultipleFilesLogWriterError.writeToFile(reason: message)
        }
        try WriterUtils.write(candidate, toFileAtPath: valid_absolutePath)
    }
    
    fileprivate static func createLogsDirectory(at path: String) {
        guard !MultipleFilesLogWriter.didCreateLogsDirectory else {
            return
        }
        self.didCreateLogsDirectory = WriterUtils.createDirectory(at: path)
    }
}

extension MultipleFilesLogWriter {
    
    fileprivate struct Constants {
        static let logFileExtension: String = ".log"
    }
}

extension MultipleFilesLogWriter {
    
    enum MultipleFilesLogWriterError: Error {
        case writeToFile(reason: String)
    }
}
