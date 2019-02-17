//
//  SingleFileLogWriter.swift
//  SimpleLogger
//
//  Created by Boyan Yankov on W07 17/Feb/2019 Sun.
//

import Foundation

protocol SingleFileLogWriter: LogWriter {
    static func update_logFileName(_ newValue: String)
    static func update_logFileMaxSizeInBytes(_ newValue: UInt64)
    static func writeToFile(_ candidate: String)
}

struct SingleFileLogWriterImpl: SingleFileLogWriter {
    
    // MARK: - Properties    
    fileprivate static var logsDirectoryPath: String = ""
    static func update_logsDirectoryPath(_ newValue: String) {
        SingleFileLogWriterImpl.logsDirectoryPath = newValue
        guard SingleFileLogWriterImpl.logsDirectoryPath.count > 0 else {
            return
        }
        SingleFileLogWriterImpl.createLogsDirectory(at: self.logsDirectoryPath)
    }
    
    fileprivate static var logFileName: String = Constants.logFileDefaultName
    static func update_logFileName(_ newValue: String) {
        self.logFileName = newValue
    }
    
    /// Defaults to `Constants.defaultLogFileSizeInMegabytes`'s value (10 MB).
    /// NOTE: Zero or negative value will prevent file deletion! (Not recommended)
    fileprivate static var logFileMaxSizeInBytes: UInt64 = Constants.defaultLogFileSizeInMegabytes * Constants.bytesInMegabyte
    static func update_logFileMaxSizeInBytes(_ newValue: UInt64) {
        SingleFileLogWriterImpl.logFileMaxSizeInBytes = newValue
    }
    
    /// We should have only one logs directory
    fileprivate static var didCreateLogsDirectory: Bool = false
    
    // MARK: - Initialization
    fileprivate init() {}
    
    // MARK: - Utils
    static func currentDirectoryPath(from candidate: String) -> String? {
        return WriterUtils.directoryPath(from: candidate)
    }
    
    static func writeToFile(_ candidate: String) {
        guard SingleFileLogWriterImpl.didCreateLogsDirectory else {
            let message: String = "Logs directory not available"
            print(message)
            return
        }
        guard let valid_logFilePath: String = SingleFileLogWriterImpl.logFilePath() else {
            let message: String = "Unable to obtain log_file_path!"
            print(message)
            return
        }
        WriterUtils.write(candidate, toFileAtPath: valid_logFilePath)
        SingleFileLogWriterImpl.cleanUpIfNeeded()
    }
    
    fileprivate static func createLogsDirectory(at path: String) {
        guard !SingleFileLogWriterImpl.didCreateLogsDirectory else {
            return
        }
        self.didCreateLogsDirectory = WriterUtils.createDirectory(at: path)
    }
    
    fileprivate static func logFilePath() -> String? {
        guard SingleFileLogWriterImpl.logsDirectoryPath.count > 0 else {
            return nil
        }
        return "\(SingleFileLogWriterImpl.logsDirectoryPath)/\(SingleFileLogWriterImpl.logFileName)"
    }
    
    fileprivate static func cleanUpIfNeeded() {
        guard let valid_logFilePath: String = SingleFileLogWriterImpl.logFilePath() else {
            return
        }
        guard SingleFileLogWriterImpl.logFileMaxSizeInBytes > 0 else {
            return
        }
        let fileSize: UInt64 = SingleFileLogWriterImpl.fileSize(at: valid_logFilePath)
        guard fileSize > SingleFileLogWriterImpl.logFileMaxSizeInBytes else {
            return
        }
        WriterUtils.removeFile(at: valid_logFilePath)
    }
    
    fileprivate static func fileSize(at path: String) -> UInt64 {
        return WriterUtils.fileSize(at: path)
    }
}

extension SingleFileLogWriterImpl {
    
    fileprivate struct Constants {
        static let logFileDefaultName: String = "logfile.log"
        static let bytesInMegabyte: UInt64 = 1024 * 1024
        static let defaultLogFileSizeInMegabytes: UInt64 = 10
    }
}
