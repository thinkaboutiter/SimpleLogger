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
    
    // MARK: Life cycle
    
    /**
     Logging a message
     - parameter message: The message to be logged
     - returns: Logger instance so additional logging methods can be chained if needed
     */
    @discardableResult
    public func message(_ message: String? = nil, filePath: String = #file, function: String = #function, line: Int = #line) -> Logger {
        // check logging
        guard self.shouldLog else { return self }
        
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
        guard self.shouldLog else { return self }
        
        // log object
        return self.log(object)
    }
    
    // MARK: - private

    
    
    /// Logging message with prefix
    @discardableResult
    fileprivate func log(_ message: String?, withSourceLocationPrefix sourceLocationPrefix: String?) -> Logger {
        
        // log
        // check for `locationPrefix`
        if let _ = sourceLocationPrefix {
            debugPrint("\(self.emojiTimePrefix) \(sourceLocationPrefix!) \(Logger.delimiter) \(message ?? "")", terminator: "\n")
        }
        else {
            debugPrint("\(self.emojiTimePrefix) \(Logger.delimiter) \(message ?? "")", terminator: "\n")
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
