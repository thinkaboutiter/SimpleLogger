//
//  SimpleLogger.swift
//  The MIT License (MIT)
//
//  Copyright (c) 2016 thinkaboutiter (thinkaboutiter@gmail.com)
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


import Foundation

public typealias Logger = SimpleLogger

/// Enum used for loggin messages and(or) objects/values.
public enum SimpleLogger: String {
    
    // info
    case general = "ℹ️"
    case debug = "🔧"
    
    // status
    case success = "✅"
    case warning = "⚠️"
    case error = "❌"
    case fatal = "💀"
    
    // data
    case network = "🌎"
    case cache = "📀"
    
    // MARK: Properies
    fileprivate(set) public static var verbosityLevel: UInt32 = Verbosity.all.rawValue
    public static func use_verbosity(_ newValue: UInt32) {
        Logger.verbosityLevel = newValue
    }
    
    fileprivate(set) public static var delimiter: String = "»"
    public static func use_delimiter(_ newValue: String) {
        Logger.delimiter = newValue
    }
    
    fileprivate(set) public static var shouldUseSourceLocationPrefix: Bool = true
    public static func enable_shouldUseSourceLocationPrefix(_ newValue: Bool) {
        Logger.shouldUseSourceLocationPrefix = newValue
    }
    
    fileprivate var emojiTimePrefix: String {
        let timeStampString: String = Logger.timestamp()
        let prefix: String = "\(self.rawValue) [\(timeStampString)]"
        return prefix
    }
    
    fileprivate var logFile_emojiTimePrefix: String {
        let timeStampString: String = Logger.logFile_timestamp()
        let prefix: String = "\(self.rawValue) [\(timeStampString)]"
        return prefix
    }
    
    fileprivate(set) static var shouldLogToFile: Bool = false
    public static func update_shouldLogToFile(_ newValue: Bool) {
        Logger.shouldLogToFile = newValue
    }
    
    fileprivate static var logWriter: LogWriter {
        return LogWriterImpl.shared
    }
    
    public static func setLogFileName(_ newValue: String) {
        Logger.logWriter.update_logFileName(newValue)
    }
    public static func setLogsDirectoryPath(_ newValue: String) {
        Logger.logWriter.update_logsDirectoryPath(newValue)
    }
    public static func logsDirectoryPath(from path: String) -> String {
        return Logger.logWriter.logsDirectoryPath(from: path)
    }
    public static func setLogFileMaxSizeInBytes(_ newValue: UInt64) {
        Logger.logWriter.update_logFileMaxSizeInBytes(newValue)
    }
    
    fileprivate var _verbosity: Verbosity {
        let resut: Verbosity
        switch self {
        case .general:
            resut = Verbosity.general
        case .debug:
            resut = Verbosity.debug
        case .success:
            resut = Verbosity.success
        case .warning:
            resut = Verbosity.warning
        case .error:
            resut = Verbosity.error
        case .fatal:
            resut = Verbosity.fatal
        case .network:
            resut = Verbosity.network
        case .cache:
            resut = Verbosity.cache
        }
        return resut
    }
    
    fileprivate var shouldLog: Bool {
        return (Logger.verbosityLevel & self._verbosity.rawValue) != 0
    }
    
    // MARK: Timestamps
    fileprivate static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    fileprivate static func timestamp() -> String {
        return Logger.dateFormatter.string(from: Date())
    }
    
    fileprivate static let logFile_dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MMM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    fileprivate static func logFile_timestamp() -> String {
        return Logger.logFile_dateFormatter.string(from: Date())
    }
    
    // MARK: - Logging
    /// Logging a message.
    /// - parameter message: The message to be logged.
    /// - parameter filePath: file in which this function is invoked.
    /// - parameter function: the outer function in which this function is invoked.
    /// - parameter line: the number of the line at which this function is invoked.
    /// - returns: Logger value so additional logging methods can be chained if needed.
    @discardableResult
    public func message(_ message: String? = nil, filePath: String = #file, function: String = #function, line: Int = #line) -> Logger {
        guard self.shouldLog else {
            return self
        }
        let sourceLocationPrefix: String?
        
        if Logger.shouldUseSourceLocationPrefix {
            let fileName: String = URL(fileURLWithPath: filePath).lastPathComponent
            sourceLocationPrefix = "\(Logger.delimiter) \(fileName) \(Logger.delimiter) \(function) \(Logger.delimiter) \(line)"
        }
        else {
            sourceLocationPrefix = nil
        }
        
        return self.log(message, sourceLocationPrefix: sourceLocationPrefix)
    }
    
    /// Logging an object.
    /// - parameter object: the object/value to be logged.
    /// - returns: Logger value so additional logging methods can be chained if needed.
    @discardableResult
    public func object(_ object: Any?) -> Logger {
        guard self.shouldLog else {
            return self
        }
        return self.log(object)
    }
    
    // MARK: - Logging Utils
    @discardableResult
    fileprivate func log(_ message: String?, sourceLocationPrefix: String?) -> Logger {
        let debugMessage: String
        if let valid_sourceLocationPrefix: String = sourceLocationPrefix {
            debugMessage = "\(self.emojiTimePrefix) \(valid_sourceLocationPrefix) \(Logger.delimiter) \(message ?? "")"
        }
        else {
            debugMessage = "\(self.emojiTimePrefix) \(Logger.delimiter) \(message ?? "")"
        }
        debugPrint(debugMessage, terminator: "\n")
        
        if Logger.shouldLogToFile {
            self.logToFile(message, sourceLocationPrefix: sourceLocationPrefix)
        }
        return self
    }
    
    fileprivate func logToFile(_ message: String?, sourceLocationPrefix: String?) {
        let logFile_message: String
        if let valid_sourceLocationPrefix: String = sourceLocationPrefix {
            logFile_message = "\(self.logFile_emojiTimePrefix) \(valid_sourceLocationPrefix) \(Logger.delimiter) \(message ?? "")"
        }
        else {
            logFile_message = "\(self.logFile_emojiTimePrefix) \(Logger.delimiter) \(message ?? "")"
        }
        Logger.logWriter.writeToFile(logFile_message)
    }
    
    @discardableResult
    fileprivate func log(_ any: Any?) -> Logger {
        #if os(Linux)
        debugPrint(any ?? "<null>", terminator: "\n\n")
        return self
        
        #else
        
        let pointer: UnsafeMutableRawPointer = Unmanaged.passUnretained(any as AnyObject).toOpaque()
        debugPrint(pointer, terminator: "\n")
        debugPrint(any as AnyObject, terminator: "\n\n")
        return self
        
        #endif
    }
}

// MARK: - Verbosity
extension SimpleLogger {
    
    public enum Verbosity: UInt32 {
        // none/all
        case none =         0x0000_0000
        case all =          0xFF
        
        // info
        case general =      0x0000_0001
        case debug =        0x0000_0002
        
        // status
        case success =      0x0000_0004
        case warning =      0x0000_0008
        case error =        0x0000_0010
        case fatal =        0x0000_0020
        
        // data
        case network =      0x0000_0040
        case cache =        0x0000_0080
    }
}
