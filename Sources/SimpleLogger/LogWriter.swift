//
//  LogWriter.swift
//  SimpleLogger
//
//  Created by Boyan Yankov on W06 08/Feb/2019 Fri.
//

import Foundation

class LogWriter {
    
    // MARK: - Properties
    static let shared: LogWriter = LogWriter()
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
    
    /// We should have only one logs directory
    fileprivate var didCreateLogsDirectory: Bool = false
    
    // MARK: - Initialization
    fileprivate init() {}
    
    // MARK: - Utils
    func logsDirectoryPath(from path: String) -> String {
        let filePathComponents: [String] = URL(fileURLWithPath: path).pathComponents
        let folderPath = "/\(filePathComponents[1..<filePathComponents.count-1].joined(separator: "/"))"
        let logsPath = "\(folderPath)/\(Constants.logsDirectoryName)"
        return logsPath
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
                Logger.error.message("error:").object(error)
            }
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
                Logger.error.message("error:").object(error)
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
}

extension LogWriter {
    
    fileprivate struct Constants {
        static let logsDirectoryName: String = "logs"
        static let logFileDefaultName: String = "logfile"
    }
}
