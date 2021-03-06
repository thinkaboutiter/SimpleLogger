//
//  SimpleLogger.swift
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
    
    private var asciiValue: String {
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
    private(set) public static var verbosityLevel: UInt32 = Verbosity.all.rawValue
    public static func setVerbosityLevel(_ newValue: UInt32) {
        Logger.verbosityLevel = newValue
    }
    
    /// Prefixes delimiter string.
    private(set) public static var delimiter: String = "»"
    public static func setDelimiter(_ newValue: String) {
        Logger.delimiter = newValue
    }
    
    /// Prefix customization.
    private(set) public static var prefix: SimpleLogger.Prefix = .emoji
    public static func setPrefix(_ newValue: SimpleLogger.Prefix) {
        Logger.prefix = newValue
    }
    
    /// Opt to log path as prefix to the log message.
    /// Disabling this may mess the sinlge log file if it is used!.
    private(set) public static var shouldLogFilePathPrefix: Bool = true
    public static func setShouldLogFilePathPrefix(_ newValue: Bool) {
        Logger.shouldLogFilePathPrefix = newValue
    }
    
    /// Used to enable writing logs into single or multiple files.
    private(set) public static var fileLogging: SimpleLogger.FileLogging = .none
    public static func setFileLogging(_ newValue: SimpleLogger.FileLogging) {
        Logger.fileLogging = newValue
    }
    
    /// Sets log file(s) directory path when logging
    public static func setLogsDirectoryPath(_ newValue: String) {
        SingleFileLogWriter.setLogsDirectoryPath(newValue)
        MultipleFilesLogWriter.setLogsDirectoryPath(newValue)
    }
    
    /// obtains current directory path when invoked
    /// precondition: when invoked with default value (#file)
    public static func currentDirectoryPath(from path: String = #file) -> String? {
        return WriterUtils.directoryPath(from: path)
    }
    
    /// Sets log file name (filename + extension) when logging to single file is enabled.
    /// default is `logfile.log`
    public static func setSingleLogFileName(_ newValue: String) {
        SingleFileLogWriter.setLogFileName(newValue)
    }
    
    /// Maximum log file size in bytes.
    /// When using single log file logging.
    /// NOTE: Zero or negative value will prevent file deletion upon reaching set max size! (Not recommended)
    public static func setSingleLogFileMaxSizeInBytes(_ newValue: UInt64) {
        SingleFileLogWriter.setLogFileMaxSizeInBytes(newValue)
    }
    
    private var timePrefix: String {
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
    
    private var logFile_timePrefix: String {
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
    
    private var _verbosity: Verbosity {
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
    
    private var shouldLog: Bool {
        return (Logger.verbosityLevel & self._verbosity.rawValue) != 0
    }
    
    // MARK: Timestamps
    private static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static func timestamp() -> String {
        return Logger.dateFormatter.string(from: Date())
    }
    
    private static let logFile_dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static func logFile_timestamp() -> String {
        return Logger.logFile_dateFormatter.string(from: Date())
    }
    
    private static let logFileName_dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static func logFileName_timestamp() -> String {
        return Logger.logFileName_dateFormatter.string(from: Date())
    }
    
    // MARK: - Logging
    /// Logging a message.
    /// - parameter message: optional message to be logged. if it is nil only date/file/function/line will be logged.
    /// - parameter writeToFile: defaults to true, can be altered per invocation so `message` won't be written into log file.
    /// - parameter scopeName: optional parameter defaults to `nil`. If used logFile with `scopeName` will be used to write the message into when `.multipleFiles` file logging is used.
    /// This can be useful if we want to crate log files based on different `scope`-s than `source_file_name`-s.
    /// - parameter filePath: file in which this function is invoked.
    /// - parameter function: the outer function in which this function is invoked.
    /// - parameter line: the number of the line at which this function is invoked.
    /// - returns: Logger value so additional logging methods can be chained if needed.
    @discardableResult
    public func message(_ message: String? = nil,
                        writeToFile: Bool = true,
                        scopeName: String? = nil,
                        filePath: String = #file,
                        function: String = #function,
                        line: Int = #line) -> Logger
    {
        guard self.shouldLog else {
            return self
        }
        
        return self.log(message: message,
                        writeToFile: writeToFile,
                        scopeName: scopeName,
                        filePath: filePath,
                        function: function,
                        line: line)
    }
    
    /// Logging an object.
    /// - parameter object: optional object/value to be logged. if it is nil only date/file/function/line will be logged.
    /// - parameter writeToFile: defaults to true, can be altered per invocation so `object` won't be written into log file.
    /// - parameter scopeName: optional parameter defaults to `nil`. If used logFile with `scopeName` will be used to write the object/value into when `.multipleFiles` file logging is used.
    /// This can be useful if we want to crate log files based on different `scope`-s than `source_file_name`-s.
    /// - parameter filePath: file in which this function is invoked.
    /// - parameter function: the outer function in which this function is invoked.
    /// - parameter line: the number of the line at which this function is invoked.
    /// - returns: Logger value so additional logging methods can be chained if needed.
    @discardableResult
    public func object(_ object: Any?,
                       writeToFile: Bool = true,
                       scopeName: String? = nil,
                       filePath: String = #file,
                       function: String = #function,
                       line: Int = #line) -> Logger
    {
        guard self.shouldLog else {
            return self
        }
        return self.log(any: object,
                        writeToFile: writeToFile,
                        scopeName: scopeName,
                        filePath: filePath,
                        function: function,
                        line: line)
    }
    
    // MARK: - Logging Utils
    /// Logging message.
    @discardableResult
    private func log(message: String?,
                     writeToFile: Bool,
                     scopeName: String?,
                     filePath: String,
                     function: String,
                     line: Int) -> Logger
    {
        let sourceLocationPrefix: String?
        if Logger.shouldLogFilePathPrefix {
            sourceLocationPrefix = self._sourceLocationPrefix(filePath: filePath,
                                                              function: function,
                                                              line: line)
        }
        else {
            sourceLocationPrefix = nil
        }
        let debugMessage: String = self._debugMessage(from: message,
                                                      timePrefix: self.timePrefix,
                                                      sourceLocationPrefix: sourceLocationPrefix)
        // console logging
        debugPrint(debugMessage, terminator: "\n")
        
        // file logging
        guard writeToFile else {
            return self
        }
        switch Logger.fileLogging {
        case .none:
            break
        case .singleFile:
            self.writeToSingleLogFile(
                message,
                sourceLocationPrefix: sourceLocationPrefix
            )
        case .multipleFiles:
            let resolved_filePath: String = scopeName ?? filePath
            self.write(
                message,
                filePath: resolved_filePath,
                sourceLocationPrefix: sourceLocationPrefix
            )
        }
        return self
    }
    
    private func _sourceLocationPrefix(filePath: String,
                                       function: String,
                                       line: Int,
                                       delimiter: String = Logger.delimiter) -> String
    {
        let fileName: String = URL(fileURLWithPath: filePath).lastPathComponent
        let result = "\(delimiter) \(fileName) \(delimiter) \(function) \(delimiter) \(line)"
        return result
    }
    
    private func _debugMessage(from message: String?,
                               timePrefix: String,
                               sourceLocationPrefix: String?,
                               delimiter: String = Logger.delimiter) -> String
    {
        let result: String
        if let valid_sourceLocationPrefix: String = sourceLocationPrefix {
            result = "\(timePrefix) \(valid_sourceLocationPrefix) \(delimiter) \(message ?? "")"
        }
        else {
            result = "\(timePrefix) \(delimiter) \(message ?? "")"
        }
        return result
    }
    
    /// Logging object.
    @discardableResult
    private func log(any: Any?,
                     writeToFile: Bool,
                     scopeName: String?,
                     filePath: String,
                     function: String,
                     line: Int) -> Logger
    {
        // console logging
        debugPrint(any ?? "<null>", terminator: "\n\n")
        
        // file logging
        guard writeToFile else {
            return self
        }
        switch Logger.fileLogging {
        case .none:
            break
        case .singleFile:
            self.writeToSingleLogFile(
                "\(any ?? "<null>")",
                sourceLocationPrefix: nil
            )
        case .multipleFiles:
            let resolved_filePath: String = scopeName ?? filePath
            self.write(
                "\(any ?? "<null>")",
                filePath: resolved_filePath,
                sourceLocationPrefix: nil
            )
        }
        return self
    }
}

// MARK: - Writing to file
extension SimpleLogger {
    
    private func writeToSingleLogFile(_ message: String?,
                                      sourceLocationPrefix: String?)
    {
        let logFile_message: String = self._logFileMessage(from: message,
                                                           sourceLocationPrefix: sourceLocationPrefix,
                                                           logFile_emojiTimePrefix: self.logFile_timePrefix,
                                                           delimiter: Logger.delimiter)
        do {
            try SingleFileLogWriter.writeToFile(logFile_message)
        }
        catch {
            print("Internal error: \(error)")
        }
    }
    
    private func write(_ message: String?,
                       filePath: String,
                       sourceLocationPrefix: String?)
    {
        let logFile_message: String = self._logFileMessage(from: message,
                                                           sourceLocationPrefix: sourceLocationPrefix,
                                                           logFile_emojiTimePrefix: self.logFile_timePrefix,
                                                           delimiter: Logger.delimiter)
        let source_fileName: String = URL(fileURLWithPath: filePath).lastPathComponent
        let logFileName: String = "\(Logger.logFileName_timestamp())-\(source_fileName)"
        do {
            try MultipleFilesLogWriter.write(logFile_message, toFile: logFileName)
        }
        catch {
            print("Internal error: \(error)")
        }
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
}

// MARK: - FileLogging
extension SimpleLogger {
    
    public enum FileLogging: UInt8 {
        case none           = 0
        case singleFile     = 1
        case multipleFiles  = 2
    }
}

// MARK: - Prefix
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
