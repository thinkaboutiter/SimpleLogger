//
//  LogWriter.swift
//  SimpleLogger
//
//  Created by Boyan Yankov on W06 08/Feb/2019 Fri.
//

import Foundation

protocol LogWriter: AnyObject {
    func update_logsDirectoryPath(_ newValue: String)
    func update_logFileName(_ newValue: String)
    func update_logFileMaxSizeInBytes(_ newValue: UInt64)
    func currentDirectoryPath(from candidate: String) -> String?
    func writeToFile(_ candidate: String)
}

class LogWriterImpl: LogWriter {
    
    // MARK: - Properties
    static let shared: LogWriterImpl = LogWriterImpl()
    
    fileprivate var logsDirectoryPath: String = ""
    func update_logsDirectoryPath(_ newValue: String) {
        self.logsDirectoryPath = newValue
        
        guard self.logsDirectoryPath.count > 0 else {
            return
        }
        self.createLogsDirecotry(at: self.logsDirectoryPath)
    }
    
    fileprivate var logFileName: String = Constants.logFileDefaultName
    func update_logFileName(_ newValue: String) {
        self.logFileName = newValue
    }
    
    /// Defaults to `Constants.defaultLogFileSizeInMegabytes`'s value (10 MB).
    /// NOTE: Zero or negative value will prevent file deletion! (Not recommended)
    fileprivate var logFileMaxSizeInBytes: UInt64 = Constants.defaultLogFileSizeInMegabytes * Constants.bytesInMegabyte
    func update_logFileMaxSizeInBytes(_ newValue: UInt64) {
        self.logFileMaxSizeInBytes = newValue
    }
    
    /// We should have only one logs directory
    fileprivate var didCreateLogsDirectory: Bool = false
    
    // MARK: - Initialization
    fileprivate init() {}
    
    // MARK: - Utils
    func currentDirectoryPath(from candidate: String) -> String? {
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
    
    func writeToFile(_ candidate: String) {
        guard self.didCreateLogsDirectory else {
            let message: String = "Logs directory not available"
            Logger.error.message(message)
            return
        }
        guard let valid_logFilePath: String = self.logFilePath() else {
            let message: String = "Unable to obtain log_file_path!"
            Logger.error.message(message)
            return
        }
        let fm = FileManager.default
        if !fm.fileExists(atPath: valid_logFilePath) {
            do {
                try "".write(toFile: valid_logFilePath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                Logger.error.message("error:\(error)")
            }
        }
        guard fm.isWritableFile(atPath: valid_logFilePath) else {
            return
        }
        guard let valid_fileHandle = FileHandle(forWritingAtPath: valid_logFilePath) else {
            let message: String = "Unable to obtain valid \(String(describing: FileHandle.self)) object!"
            Logger.error.message(message)
            return
        }
        let stringToWrite = "\(candidate)\n"
        valid_fileHandle.seekToEndOfFile()
        
        guard let valid_data: Data = stringToWrite.data(using: String.Encoding.utf8) else {
            let message: String = "Unable to obtain valid \(String(describing: Data.self)) object from candidate=\(stringToWrite)!"
            Logger.error.message(message)
            return
        }
        valid_fileHandle.write(valid_data)
        valid_fileHandle.closeFile()
        
        self.cleanUpIfNeeded()
    }
    
    fileprivate func createLogsDirecotry(at path: String) {
        guard !self.didCreateLogsDirectory else {
            return
        }
        
        let fm: FileManager = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
                self.didCreateLogsDirectory = true
            }
            catch {
                Logger.error.message("error:\(error)")
            }
        }
        else {
            self.didCreateLogsDirectory = true
        }
    }
    
    fileprivate func logFilePath() -> String? {
        guard self.logsDirectoryPath.count > 0 else {
            return nil
        }
        return "\(self.logsDirectoryPath)/\(self.logFileName)"
    }
    
    fileprivate func cleanUpIfNeeded() {
        guard let valid_logFilePath: String = self.logFilePath() else {
            return
        }
        let fm = FileManager.default
        guard fm.fileExists(atPath: valid_logFilePath) else {
            return
        }
        let fileSize: UInt64 = self.fileSize(at: valid_logFilePath)
        
        guard self.logFileMaxSizeInBytes > 0 else {
            return
        }
        guard fileSize > self.logFileMaxSizeInBytes else {
            return
        }

        do {
            try fm.removeItem(atPath: valid_logFilePath)
        }
        catch {
            Logger.error.message("error:\(error)")
        }
    }
    
    fileprivate func fileSize(at path: String) -> UInt64 {
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

extension LogWriterImpl {
    
    fileprivate struct Constants {
        static let logFileDefaultName: String = "logfile.log"
        static let bytesInMegabyte: UInt64 = 1024 * 1024
        static let defaultLogFileSizeInMegabytes: UInt64 = 10
    }
}
