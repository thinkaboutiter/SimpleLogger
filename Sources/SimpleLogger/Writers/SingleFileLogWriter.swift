//
//  SingleFileLogWriter.swift
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

/// Logging in one single file.
struct SingleFileLogWriter {
    
    // MARK: - Properties    
    private static var logsDirectoryPath: String = ""
    static func setLogsDirectoryPath(_ newValue: String) {
        SingleFileLogWriter.logsDirectoryPath = newValue
        guard SingleFileLogWriter.logsDirectoryPath.count > 0 else {
            return
        }
        SingleFileLogWriter.createLogsDirectory(at: self.logsDirectoryPath)
    }
    
    private static var logFileName: String = Constants.defaultLogFileName
    static func setLogFileName(_ newValue: String) {
        self.logFileName = newValue
    }
    
    /// Defaults to `Constants.defaultLogFileSizeInMegabytes`'s value (10 MB).
    /// NOTE: Zero or negative value will prevent file deletion! (Not recommended)
    private static var logFileMaxSizeInBytes: UInt64 = Constants.defaultLogFileSizeInMegabytes * Constants.bytesInMegabyte
    static func setLogFileMaxSizeInBytes(_ newValue: UInt64) {
        SingleFileLogWriter.logFileMaxSizeInBytes = newValue
    }
    
    /// We should create logs directory only once
    private static var didCreateLogsDirectory: Bool = false
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Utils    
    static func writeToFile(_ candidate: String) throws {
        guard SingleFileLogWriter.didCreateLogsDirectory else {
            let message: String = "Logs directory not available"
            throw Error.writeToFile(reason: message)
        }
        guard let valid_logFilePath: String = SingleFileLogWriter.logFilePath() else {
            let message: String = "Unable to obtain log_file_path!"
            throw Error.writeToFile(reason: message)
        }
        try WriterUtils.write(candidate, toFileAtPath: valid_logFilePath)
        try SingleFileLogWriter.cleanUpIfNeeded()
    }
    
    private static func createLogsDirectory(at path: String) {
        guard !SingleFileLogWriter.didCreateLogsDirectory else {
            return
        }
        self.didCreateLogsDirectory = WriterUtils.createDirectory(at: path)
    }
    
    private static func logFilePath() -> String? {
        guard SingleFileLogWriter.logsDirectoryPath.count > 0 else {
            return nil
        }
        let candidate: String = "\(SingleFileLogWriter.logsDirectoryPath)/\(SingleFileLogWriter.logFileName)"
        guard let valid_absoulutePathString: String = WriterUtils.absoulutePathString(from: candidate) else {
            return nil
        }
        return valid_absoulutePathString
    }
    
    private static func cleanUpIfNeeded() throws {
        guard SingleFileLogWriter.logFileMaxSizeInBytes > 0 else {
            return
        }
        guard let valid_logFilePath: String = SingleFileLogWriter.logFilePath() else {
            let message: String = "Invalid log file path!"
            throw Error.removeFile(reason: message)
        }
        let fileSize: UInt64 = SingleFileLogWriter.fileSize(at: valid_logFilePath)
        guard fileSize > SingleFileLogWriter.logFileMaxSizeInBytes else {
            return
        }
        try WriterUtils.removeFile(at: valid_logFilePath)
    }
    
    private static func fileSize(at path: String) -> UInt64 {
        return WriterUtils.fileSize(at: path)
    }
}

private extension SingleFileLogWriter {
     enum Constants {
        static let defaultLogFileName: String = "logfile.log"
        static let bytesInMegabyte: UInt64 = 1024 * 1024
        static let defaultLogFileSizeInMegabytes: UInt64 = 10
    }
}

extension SingleFileLogWriter {
    enum Error: Swift.Error {
        case writeToFile(reason: String)
        case removeFile(reason: String)
    }
}
