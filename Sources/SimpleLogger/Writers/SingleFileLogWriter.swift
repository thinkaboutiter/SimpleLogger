//
//  SingleFileLogWriter.swift
//  SimpleLogger
//
//  Created by Boyan Yankov on W07 17/Feb/2019 Sun.
//

import Foundation

/// Logging in one single file.
struct SingleFileLogWriter {
    
    // MARK: - Properties    
    fileprivate static var logsDirectoryPath: String = ""
    static func setLogsDirectoryPath(_ newValue: String) {
        SingleFileLogWriter.logsDirectoryPath = newValue
        guard SingleFileLogWriter.logsDirectoryPath.count > 0 else {
            return
        }
        SingleFileLogWriter.createLogsDirectory(at: self.logsDirectoryPath)
    }
    
    fileprivate static var logFileName: String = Constants.defaultLogFileName
    static func setLogFileName(_ newValue: String) {
        self.logFileName = newValue
    }
    
    /// Defaults to `Constants.defaultLogFileSizeInMegabytes`'s value (10 MB).
    /// NOTE: Zero or negative value will prevent file deletion! (Not recommended)
    fileprivate static var logFileMaxSizeInBytes: UInt64 = Constants.defaultLogFileSizeInMegabytes * Constants.bytesInMegabyte
    static func setLogFileMaxSizeInBytes(_ newValue: UInt64) {
        SingleFileLogWriter.logFileMaxSizeInBytes = newValue
    }
    
    /// We should create logs directory only once
    fileprivate static var didCreateLogsDirectory: Bool = false
    
    // MARK: - Initialization
    fileprivate init() {}
    
    // MARK: - Utils    
    static func writeToFile(_ candidate: String) throws {
        guard SingleFileLogWriter.didCreateLogsDirectory else {
            let message: String = "Logs directory not available"
            throw SingleFileLogWriterError.writeToFile(reason: message)
        }
        guard let valid_logFilePath: String = SingleFileLogWriter.logFilePath() else {
            let message: String = "Unable to obtain log_file_path!"
            throw SingleFileLogWriterError.writeToFile(reason: message)
        }
        try WriterUtils.write(candidate, toFileAtPath: valid_logFilePath)
        try SingleFileLogWriter.cleanUpIfNeeded()
    }
    
    fileprivate static func createLogsDirectory(at path: String) {
        guard !SingleFileLogWriter.didCreateLogsDirectory else {
            return
        }
        self.didCreateLogsDirectory = WriterUtils.createDirectory(at: path)
    }
    
    fileprivate static func logFilePath() -> String? {
        guard SingleFileLogWriter.logsDirectoryPath.count > 0 else {
            return nil
        }
        let candidate: String = "\(SingleFileLogWriter.logsDirectoryPath)/\(SingleFileLogWriter.logFileName)"
        guard let valid_absoulutePathString: String = WriterUtils.absoulutePathString(from: candidate) else {
            return nil
        }
        return valid_absoulutePathString
    }
    
    fileprivate static func cleanUpIfNeeded() throws {
        guard SingleFileLogWriter.logFileMaxSizeInBytes > 0 else {
            return
        }
        guard let valid_logFilePath: String = SingleFileLogWriter.logFilePath() else {
            let message: String = "Invalid log file path!"
            throw SingleFileLogWriterError.removeFile(reason: message)
        }
        let fileSize: UInt64 = SingleFileLogWriter.fileSize(at: valid_logFilePath)
        guard fileSize > SingleFileLogWriter.logFileMaxSizeInBytes else {
            return
        }
        try WriterUtils.removeFile(at: valid_logFilePath)
    }
    
    fileprivate static func fileSize(at path: String) -> UInt64 {
        return WriterUtils.fileSize(at: path)
    }
}

extension SingleFileLogWriter {
    
    fileprivate struct Constants {
        static let defaultLogFileName: String = "logfile.log"
        static let bytesInMegabyte: UInt64 = 1024 * 1024
        static let defaultLogFileSizeInMegabytes: UInt64 = 10
    }
}

extension SingleFileLogWriter {
    enum SingleFileLogWriterError: Error {
        case writeToFile(reason: String)
        case removeFile(reason: String)
    }
}
