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
    
    // MARK: Properies, Accessors
    
    // logging configration
    fileprivate static var isLoggingEnabled: Bool = false
    
    /**
     Enable / Disable logging
     - parameter _: boolean flag to enable / disable logging
     */
    public static func enableLogging(_ newValue: Bool) {
        Logger.isLoggingEnabled = newValue
    }
    
    // location prefix
    fileprivate static var shouldUseSourceLocationPrefix: Bool = true
    /**
     Enable / Disable locationPrefix - file, function and line where the log is called from
     - parameter _: boolean flag to enable / disable locationPrefix
     */
    public static func enableSourceLocationPrefix(_ newValue: Bool) {
        Logger.shouldUseSourceLocationPrefix = newValue
    }
    
    // verbosity
    fileprivate static var verbosity: Logger.Verbosity = .full
    
    /**
     Changes verbosity level
     - parameter _: New verbosity level
     */
    public static func useVerbosity(_ newValue: Logger.Verbosity) {
        Logger.verbosity = newValue
    }
    
    // delimiter
    fileprivate static var delimiter: String = "»"
    
    /**
     Changes the delimiter string
     - parameter _: New delimiter string
     */
    public static func useDelimiter(_ newValue: String) {
        Logger.delimiter = newValue
    }
    
    // MARK: Life cycle
    
    /**
     Logging a message
     - parameter message: The message to be logged
     - returns: Logger instance so additional logging methods can be chained if needed
     */
    @discardableResult
    public func message(_ message: String? = nil, filePath: String = #file, function: String = #function, line: Int = #line) -> Logger {
        // check logging
        guard self.shouldLog() else { return self }
        
        // location prefix with format [file, function, line]
        let sourceLocationPrefix: String?
        
        // check if `locationPrefix` should be included
        if Logger.shouldUseSourceLocationPrefix {
            
            // create locationInfix
            let fileName: String = URL(fileURLWithPath: filePath).lastPathComponent
            sourceLocationPrefix = "\(Logger.delimiter) \(fileName) \(Logger.delimiter) \(function) \(Logger.delimiter) \(line)"
        }
        else {
            sourceLocationPrefix = nil
        }
        
        // log message
        return self.log(message, withSourceLocationPrefix: sourceLocationPrefix)
    }
    
    /**
     Logging an object
     - parameter object: The object to be logged
     - returns: Logger instance so additional logging methods can be chained if needed
     */
    @discardableResult
    public func object(_ object: Any?) -> Logger {
        // check logging
        guard self.shouldLog() else { return self }
        
        // log object
        return self.log(object)
    }
    
    // MARK: - private
    
    fileprivate func shouldLog() -> Bool {
        // check logging
        guard Logger.isLoggingEnabled else { return false }
        
        // swith over self and verbosity to produce logs or not
        switch (Logger.verbosity, self) {
            
        // log info
        case (.info, let state) where state == .general || state == .debug:
            return true
            
        // log status
        case (.status, let state) where state == .success || state == .warning || state == .error || state == .fatal:
            return true
            
        // log data
        case (.data, let state) where state == .network || state == .cache:
            return true
            
        // log info and data
        case (.infoAndData, let state) where state != .success && state != .warning && state != .error && state != .fatal:
            return true
            
        // log info and status
        case (.infoAndStatus, let state) where state != .network && state != .cache:
            return true
            
        // log data and status
        case (.dataAndStatus, let state) where state != .general && state != .debug:
            return true
            
        // log full
        case (.full, _):
            return true
            
        default:
            // no logging
            return false
        }
    }
    
    fileprivate func emojiTimePrefix() -> String {
        // get timeStamp
        let timeStampString: String = Logger.timestamp()
        let prefix: String = "\(self.rawValue) [\(timeStampString)]"
        
        return prefix
    }
    
    /// Logging message with prefix
    @discardableResult
    fileprivate func log(_ message: String?, withSourceLocationPrefix sourceLocationPrefix: String?) -> Logger {
        
        // log
        // check for `locationPrefix`
        if let _ = sourceLocationPrefix {
            debugPrint("\(self.emojiTimePrefix()) \(sourceLocationPrefix!) \(Logger.delimiter) \(message ?? "")", terminator: "\n")
        }
        else {
            debugPrint("\(self.emojiTimePrefix()) \(Logger.delimiter) \(message ?? "")", terminator: "\n")
        }
        
        return self
    }
    
    /// Logging object
    @discardableResult
    fileprivate func log(_ object: Any?) -> Logger {
        
        debugPrint(Unmanaged.passUnretained(object as AnyObject).toOpaque(), terminator: "\n")
        debugPrint(object as AnyObject, terminator: "\n\n")
        
        return self
    }
    
    // MARK: Timestamp
    
    fileprivate static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    fileprivate static func timestamp() -> String {
        return Logger.dateFormatter.string(from: Date())
    }
}

// MARK: - Verbosity

extension SimpleLogger {
    
    public enum Verbosity {
        
        // single
        case info   // log info
        case data   // log data
        case status // log status
        
        // mixed
        case infoAndData    // log info + data
        case infoAndStatus  // log info + status
        case dataAndStatus  // log date + status
        
        // Full
        case full // log everything
    }
}
