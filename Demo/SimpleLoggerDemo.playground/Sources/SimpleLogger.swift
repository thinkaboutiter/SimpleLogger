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
    private static var isLoggingEnabled: Bool = false
    public static func enableLogging(_ newValue: Bool) {
        Logger.isLoggingEnabled = newValue
    }
    
    // verbosity
    private static var verbosity: Logger.Verbosity = .full
    public static func useVerbosity(_ newValue: Logger.Verbosity) {
        Logger.verbosity = newValue
    }
    
    // MARK: Life cycle
    
    public func message(_ message: String) -> Logger {
        // check logging
        guard Logger.isLoggingEnabled else { return self }
        
        let prefix: String
        
        // swith over self and verbosity to produce logs or not
        switch (Logger.verbosity, self) {
        
        // log information
        case (.info, let state) where state == .general || state == .debug:
            prefix = state.rawValue
            
        // log status
        case (.status, let state) where state == .success || state == .warning || state == .error || state == .fatal:
            prefix = state.rawValue
            
        // log data
        case (.data, let state) where state == .network || state == .cache:
            prefix = state.rawValue
            
        // log info and data
        case (.infoAndData, let state) where state != .success && state != .warning && state != .error && state != .fatal:
            prefix = state.rawValue
            
        // log info and status
        case (.infoAndStatus, let state) where state != .network && state != .cache:
            prefix = state.rawValue
            
        case (.dataAndStatus, let state) where state != .general && state != .debug:
            prefix = state.rawValue

        // log full
        case (.full, let state):
            prefix = state.rawValue
            
        default:
            // no logging
            return self
        }
        
         return self.log(message, withPrefix: prefix)
    }
    
    public func object(_ object: Any?) -> Logger {
        // check logging
        guard Logger.isLoggingEnabled else { return self }
        
        return self.log(object)
    }
    
    private func log(_ message: String, withPrefix prefix: String) -> Logger {
        // TODO: get timeStamp
        let timeStampString: String = "TimeStamp"
        
        let output: String = "\(prefix) [\(timeStampString)] \(message)"
        
        // log
        debugPrint(output)
        
        return self
    }
    
    private func log(_ object: Any?) -> Logger {
        
        // print object if any
        if let validObject: AnyObject = object as AnyObject? {
            debugPrint(Unmanaged.passUnretained(validObject).toOpaque(), separator: " ", terminator: "\n")
            debugPrint(validObject, separator: "", terminator: "\n\n")
        }
        else {
            debugPrint("\(object ?? String())", separator: "", terminator: "\n\n")
        }
        
        return self
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
