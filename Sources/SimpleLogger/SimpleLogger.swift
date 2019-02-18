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
    
    fileprivate var asciiValue: String {
        let result: String
        switch self {
        case .general:
            result = "GENERAL"
        case .debug:
            result = "DEBUG"
        case .success:
            result = "SUCCESS"
        case .warning:
            result = "WARNING"
        case .error:
            result = "ERROR"
        case .fatal:
            result = "FATAL"
        case .network:
            result = "NETWORK"
        case .cache:
            result = "CACHE"
        }
        return result
    }
    
    // MARK: Properies
    /// Logging verbosity (using verbosity toggles).
    fileprivate(set) public static var verbosityLevel: UInt32 = Verbosity.all.rawValue
    public static func use_verbosity(_ newValue: UInt32) {
        Logger.verbosityLevel = newValue
    }
    
    /// Prefixes delimiter string.
    fileprivate(set) public static var delimiter: String = "»"
    public static func use_delimiter(_ newValue: String) {
        Logger.delimiter = newValue
    }
    
    /// Prefix customization.
    fileprivate(set) public static var prefix: SimpleLogger.Prefix = .emoji
    public static func use_prefix(_ newValue: SimpleLogger.Prefix) {
        Logger.prefix = newValue
    }
    
    /// Opt to log path as prefix to the log message.
    /// Disabling this may mess the sinlge log file if it is used!.
    fileprivate(set) public static var shouldLogPathPrefix: Bool = true
    public static func enable_shouldLogPathPrefix(_ newValue: Bool) {
        Logger.shouldLogPathPrefix = newValue
    }
    
    fileprivate var timePrefix: String {
        let result: String
        switch Logger.prefix {
        case .ascii:
            result = self._asciiTimePrefix
        case .emoji:
            result = self._emojiTimePrefix
        }
        return result
    }
    
    private var _emojiTimePrefix: String {
        let timeStampString: String = Logger.timestamp()
        let prefix: String = "\(self.rawValue) [\(timeStampString)]"
        return prefix
    }
    
    private var _asciiTimePrefix: String {
        let timeStampString: String = Logger.timestamp()
        let prefix: String = "\(self.asciiValue) [\(timeStampString)]"
        return prefix
    }
    
    fileprivate var logFile_timePrefix: String {
        let result: String
        switch Logger.prefix {
        case .ascii:
            result = self._logFile_asciiTimePrefix
        case .emoji:
            result = self._logFile_emojiTimePrefix
        }
        return result
    }
    
    private var _logFile_emojiTimePrefix: String {
        let timeStampString: String = Logger.logFile_timestamp()
        let prefix: String = "\(self.rawValue) [\(timeStampString)]"
        return prefix
    }
    
    private var _logFile_asciiTimePrefix: String {
        let timeStampString: String = Logger.logFile_timestamp()
        let prefix: String = "\(self.asciiValue)\t [\(timeStampString)]"
        return prefix
    }
    
    fileprivate(set) static var fileLogging: SimpleLogger.FileLogging = .none
    public static func update_fileLogging(_ newValue: SimpleLogger.FileLogging) {
        Logger.fileLogging = newValue
    }
    
    /// Sets log file name (filename + extension) when logging to single file is enabled.
    /// default is `logfile.log`
    public static func setSingleLogFileName(_ newValue: String) {
        SingleFileLogWriter.update_logFileName(newValue)
    }
    
    /// Sets log file(s) directory path when logging
    public static func setLogsDirectoryPath(_ newValue: String) {
        SingleFileLogWriter.update_logsDirectoryPath(newValue)
        MultipleFilesLogWriter.update_logsDirectoryPath(newValue)
    }
    
    /// obtains current directory path when invoked
    /// precondition: when invoked with default value (#file)
    public static func currentDirectoryPath(from path: String = #file) -> String? {
        return WriterUtils.directoryPath(from: path)
    }
    
    /// Maximum log file size in bytes.
    /// When using single log file logging.
    /// NOTE: Zero or negative value will prevent file deletion upon reaching set max size! (Not recommended)
    public static func setSingleLogFileMaxSizeInBytes(_ newValue: UInt64) {
        SingleFileLogWriter.update_logFileMaxSizeInBytes(newValue)
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
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    fileprivate static func logFile_timestamp() -> String {
        return Logger.logFile_dateFormatter.string(from: Date())
    }
    
    fileprivate static let logFileName_dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    fileprivate static func logFileName_timestamp() -> String {
        return Logger.logFileName_dateFormatter.string(from: Date())
    }
    
    // MARK: - Logging
    /// Logging a message.
    /// - parameter message: The message to be logged.
    /// - parameter filePath: file in which this function is invoked.
    /// - parameter function: the outer function in which this function is invoked.
    /// - parameter line: the number of the line at which this function is invoked.
    /// - returns: Logger value so additional logging methods can be chained if needed.
    @discardableResult
    public func message(_ message: String? = nil,
                        filePath: String = #file,
                        function: String = #function,
                        line: Int = #line) -> Logger
    {
        guard self.shouldLog else {
            return self
        }
        
        return self.log(message: message,
                        filePath: filePath,
                        function: function,
                        line: line)
    }
    
    /// Logging an object.
    /// - parameter object: the object/value to be logged.
    /// - returns: Logger value so additional logging methods can be chained if needed.
    @discardableResult
    public func object(_ object: Any?,
                       filePath: String = #file,
                       function: String = #function,
                       line: Int = #line) -> Logger
    {
        guard self.shouldLog else {
            return self
        }
        return self.log(any: object,
                        filePath: filePath,
                        function: function,
                        line: line)
    }
    
    // MARK: - Logging Utils
    /// Logging message.
    @discardableResult
    fileprivate func log(message: String?,
                         filePath: String,
                         function: String,
                         line: Int) -> Logger
    {
        let sourceLocationPrefix: String?
        if Logger.shouldLogPathPrefix {
            sourceLocationPrefix = self._sourceLocationPrefix(filePath: filePath,
                                                              function: function,
                                                              line: line,
                                                              delimiter: Logger.delimiter)
        }
        else {
            sourceLocationPrefix = nil
        }
        let debugMessage: String = self._debugMessage(from: message,
                                                      sourceLocationPrefix: sourceLocationPrefix,
                                                      emojiTimePrefix: self.timePrefix,
                                                      delimiter: Logger.delimiter)
        // console logging
        debugPrint(debugMessage, terminator: "\n")
        
        // file logging
        switch Logger.fileLogging {
        case .none:
            break
        case .singleFile:
            self.writeToSingleLogFile(message,
                                      sourceLocationPrefix: sourceLocationPrefix)
        case .multipleFiles:
            self.write(message,
                       filePath: filePath,
                       sourceLocationPrefix: sourceLocationPrefix)
        }
        return self
    }
    
    private func _sourceLocationPrefix(filePath: String,
                                       function: String,
                                       line: Int,
                                       delimiter: String) -> String
    {
        let fileName: String = URL(fileURLWithPath: filePath).lastPathComponent
        let result = "\(delimiter) \(fileName) \(delimiter) \(function) \(delimiter) \(line)"
        return result
    }
    
    private func _debugMessage(from message: String?,
                               sourceLocationPrefix: String?,
                               emojiTimePrefix: String,
                               delimiter: String) -> String
    {
        let result: String
        if let valid_sourceLocationPrefix: String = sourceLocationPrefix {
            result = "\(emojiTimePrefix) \(valid_sourceLocationPrefix) \(delimiter) \(message ?? "")"
        }
        else {
            result = "\(emojiTimePrefix) \(delimiter) \(message ?? "")"
        }
        return result
    }
    
    fileprivate func writeToSingleLogFile(_ message: String?,
                                          sourceLocationPrefix: String?)
    {
        let logFile_message: String = self._logFileMessage(from: message,
                                                           sourceLocationPrefix: sourceLocationPrefix,
                                                           logFile_emojiTimePrefix: self.logFile_timePrefix,
                                                           delimiter: Logger.delimiter)
        SingleFileLogWriter.writeToFile(logFile_message)
    }
    
    private func _logFileMessage(from message: String?,
                                 sourceLocationPrefix: String?,
                                 logFile_emojiTimePrefix: String,
                                 delimiter: String) -> String
    {
        let result: String
        if let valid_sourceLocationPrefix: String = sourceLocationPrefix {
            result = "\(logFile_emojiTimePrefix) \(valid_sourceLocationPrefix) \(delimiter) \(message ?? "")"
        }
        else {
            result = "\(logFile_emojiTimePrefix) \(delimiter) \(message ?? "")"
        }
        return result
    }
    
    fileprivate func write(_ message: String?,
                           filePath: String,
                           sourceLocationPrefix: String?)
    {
        let logFile_message: String = self._logFileMessage(from: message,
                                                           sourceLocationPrefix: sourceLocationPrefix,
                                                           logFile_emojiTimePrefix: self.logFile_timePrefix,
                                                           delimiter: Logger.delimiter)
        let source_fileName: String = URL(fileURLWithPath: filePath).lastPathComponent
        let logFileName: String = "\(Logger.logFileName_timestamp())-\(source_fileName)"
        MultipleFilesLogWriter.write(logFile_message, toFile: logFileName)

    }
    
    /// Logging object.
    @discardableResult
    fileprivate func log(any: Any?,
                         filePath: String,
                         function: String,
                         line: Int) -> Logger
    {
        // file logging
        switch Logger.fileLogging {
        case .none:
            break
        case .singleFile:
            self.writeToSingleLogFile("\(any ?? "<null>")", sourceLocationPrefix: nil)
        case .multipleFiles:
            self.write("\(any ?? "<null>")", filePath: filePath, sourceLocationPrefix: nil)
        }
        
        // console logging
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

// MARK: - Logging to file
extension SimpleLogger {
    
    public enum FileLogging: UInt8 {
        case none           = 0
        case singleFile     = 1
        case multipleFiles  = 2
    }
}

// MARK: - Prefix type
extension SimpleLogger {
    
    public enum Prefix: UInt8 {
        case ascii = 0
        case emoji = 1
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
