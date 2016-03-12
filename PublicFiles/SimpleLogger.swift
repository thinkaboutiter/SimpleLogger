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

// MARK: - SimpleLogger

public class SimpleLogger: NSObject {
    
    // MARK: LogLevel
    
    private enum LogLevel: UInt {
        case Default
        case Custom
        case Debug
        case Error
        case Warning
        case Success
        case Info
        case Network
        case Cache
        
        // Emojies
        private func emojiSymbol() -> String {
            switch self {
            case .Default:
                return "💭"
                
            case .Custom:
                return "💡"
                
            case .Debug:
                return "🔧"
                
            case .Error:
                return "❌"
                
            case .Warning:
                return "⚠️"
                
            case .Success:
                return "✅"
                
            case .Info:
                return "ℹ️"
                
            case .Network:
                return "🌎"
                
            case .Cache:
                return "📀"
            }
        }
    }
    
    // logging configration
    private static var isLoggingEnabled: Bool = false
    
    // logging emoji symbol prefix
    private static var emojiSymbol: String = LogLevel.emojiSymbol(.Default)()
    
    // MARK: enable / disable logging
    
    public static func enableLogging(isLoggingEnabled: Bool) {
        Logger.isLoggingEnabled = isLoggingEnabled
    }
    
    // MARK: - logging API
    
    /** Logs passed `message` in the consloe. Chainable */
    public static func logMessage(message: String?) -> Logger.Type {
        Logger._logMessage(message)
        return self
    }
    
    /** Logs passed `object` in the consloe. Chainable */
    public static func logObject(object: AnyObject?) -> Logger.Type {
        Logger._logObject(object)
        return self
    }
    
    // MARK: emoji symbol prefix update
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logDefault() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Default)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logCustom() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Custom)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logDebug() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Debug)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logError() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Error)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logWarning() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Warning)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logSuccess() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Success)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logInfo() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Info)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logNetwork() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Network)()
        return self
    }
    
    /** updates `emojiSymbol` for the next `_log()` call */
    public static func logCache() -> Logger.Type {
        Logger.emojiSymbol = LogLevel.emojiSymbol(.Cache)()
        return self
    }
    
    // MARK: Deprecated Logging
    
    /** Logs `Custom` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logCustom()` and chain some additional funcitionality")
    public static func logCustom(message: String?, item: AnyObject?) {
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Custom)
    }
    
    /** Logs `Debug` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logDebug()` and chain some additional funcitionality")
    public static func logDebug(message: String?, item: AnyObject?) {
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Debug)
    }
    
    /** Logs `Error` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logError()` and chain some additional funcitionality")
    public static func logError(message: String?, item: AnyObject?) {
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Error)
    }
    
    /** Logs `Warning` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logWarning()` and chain some additional funcitionality")
    public static func logWarning(message: String?, item: AnyObject?) {
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Warning)
    }
    
    /** Logs `Success` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logSuccess()` and chain some additional funcitionality")
    public static func logSuccess(message: String?, item: AnyObject?){
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Success)
    }
    
    /** Logs `Info` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logInfo()` and chain some additional funcitionality")
    public static func logInfo(message: String?, item: AnyObject?) {
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Info)
    }
    
    /** Logs `Network` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logNetwork()` and chain some additional funcitionality")
    public static func logNetwork(message: String?, item: AnyObject?) {
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Network)
    }
    
    /** Logs `Cache` log `message` and passed `item` if any */
    @available(*, deprecated, message="Use `logCache()` and chain some additional funcitionality")
    public static func logCache(message: String?, item: AnyObject?) {
        SimpleLogger.log(message, item: item, withLogLevel: LogLevel.Cache)
    }
    
    // MARK: - Helpers
    
    /** Logs glyph prefixed time stamped message */
    private static func _logMessage(message: Any?) {
        if Logger.isLoggingEnabled {
            let outputString = " \(Logger.emojiSymbol) [\(Logger.getTimestamp())] \(message ?? String())"
            
            // print prefix
            debugPrint(outputString, separator: "", terminator: "\n")
        }
    }
    
    /** Logs glyph prefixed time stamped message */
    private static func _logObject(object: AnyObject?) {
        if Logger.isLoggingEnabled {
            
            // print object if any
            if let validObject = object {
                debugPrint(unsafeAddressOf(validObject), separator: " ", terminator: "\n")
                debugPrint(validObject, separator: "", terminator: "\n\n")
            }
        }
    }
    
    /** Logs if `isLoggingEnabled` is set */
    @available(*, deprecated=0.1.5)
    private static func log(message: String?, item: AnyObject?, withLogLevel logLevel: LogLevel) {
        if SimpleLogger.isLoggingEnabled {
            SimpleLogger.logMessage(message, item: item, withLogLevel: logLevel)
        }
    }
    
    /** Logs glyph prefixed `message` and passed `item` if any */
    @available(*, deprecated=0.1.5)
    private static func logMessage(message: String?, item: AnyObject?, withLogLevel logLevel: LogLevel) {
        let prefix = " \(logLevel.emojiSymbol()) [\(Logger.getTimestamp())] \(message ?? String())"
        
        // print prefix
        debugPrint(prefix, separator: "", terminator: "\n")
        
        // print item if any
        if let item = item {
            debugPrint(item, separator: "", terminator: "\n\n")
        }
    }
    
    private static let timestampDateTimeFormatter : NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        return formatter
    }()
    
    private static func getTimestamp() -> String {
        return SimpleLogger.timestampDateTimeFormatter.stringFromDate(NSDate())
    }
}
