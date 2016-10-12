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

    // information
    case general = "📝"
    case debug = "🔧"
    case info = "ℹ️"
    
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
    
    public func message(_ message: String) {
        // check logging
        guard Logger.isLoggingEnabled else { return }
        
        // TODO: swith over self and verbosity to produce logs or not
    }
}

// MARK: - Verbosity

extension SimpleLogger {
    
    public enum Verbosity {
        case full // log everything
        case medium // log information + data
        case low // log information + status
        case veryLow // log information
    }
}
