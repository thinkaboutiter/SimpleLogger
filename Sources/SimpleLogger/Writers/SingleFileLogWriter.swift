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
//    static let shared: LogWriterImpl = LogWriterImpl()
    
    fileprivate static var logsDirectoryPath: String = ""
    static func update_logsDirectoryPath(_ newValue: String) {
        SingleFileLogWriterImpl.logsDirectoryPath = newValue
        
        guard SingleFileLogWriterImpl.logsDirectoryPath.count > 0 else {
            return
        }
        SingleFileLogWriterImpl.createLogsDirecotry(at: self.logsDirectoryPath)
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
        let fm = FileManager.default
        if !fm.fileExists(atPath: valid_logFilePath) {
            do {
                try "".write(toFile: valid_logFilePath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                print("error:\(error)")
            }
        }
        guard fm.isWritableFile(atPath: valid_logFilePath) else {
            return
        }
        guard let valid_fileHandle = FileHandle(forWritingAtPath: valid_logFilePath) else {
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
        
        SingleFileLogWriterImpl.cleanUpIfNeeded()
    }
    
    fileprivate static func createLogsDirecotry(at path: String) {
        guard !SingleFileLogWriterImpl.didCreateLogsDirectory else {
            return
        }
        
        let fm: FileManager = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
                SingleFileLogWriterImpl.didCreateLogsDirectory = true
            }
            catch {
                print("error:\(error)")
            }
        }
        else {
            SingleFileLogWriterImpl.didCreateLogsDirectory = true
        }
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
        let fm = FileManager.default
        guard fm.fileExists(atPath: valid_logFilePath) else {
            return
        }
        let fileSize: UInt64 = SingleFileLogWriterImpl.fileSize(at: valid_logFilePath)
        
        guard SingleFileLogWriterImpl.logFileMaxSizeInBytes > 0 else {
            return
        }
        guard fileSize > SingleFileLogWriterImpl.logFileMaxSizeInBytes else {
            return
        }
        
        do {
            try fm.removeItem(atPath: valid_logFilePath)
        }
        catch {
            print("error:\(error)")
        }
    }
    
    fileprivate static func fileSize(at path: String) -> UInt64 {
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

extension SingleFileLogWriterImpl {
    
    fileprivate struct Constants {
        static let logFileDefaultName: String = "logfile.log"
        static let bytesInMegabyte: UInt64 = 1024 * 1024
        static let defaultLogFileSizeInMegabytes: UInt64 = 10
    }
}
