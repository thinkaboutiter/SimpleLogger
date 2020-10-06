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
import SimpleLogger

let messge_start: String = "Starting Simple logger excercise!"
debugPrint("🔧 \(#file) » \(#function) » \(#line)", messge_start, separator: "\n")

private func log_message() {
    // info
    Logger.general.message("Logging `genereal` message")
    Logger.debug.message("Logging `debug` message")
    
    // status
    Logger.success.message("Logging `success` message")
    Logger.warning.message("Logging `warning` message")
    Logger.error.message("Logging `error` message")
    Logger.fatal.message("Logging `fatal` message")
    
    // data
    Logger.network.message("Logging `network` message")
    Logger.cache.message("Logging `cache` message")
}

private func log_objects() {
    // array
    let sampleArray: [Int] = [
        0,
        1,
        2,
        3
    ]
    Logger.debug.message("Array:").object(sampleArray)
    
    // dictionary
    let sampleDictionary: [String: String] = [
        "key_0": "value_0",
        "key_1": "value_1",
        "key_2": "value_2",
        "key_3": "value_3"
    ]
    Logger.debug.message("Dictionary:").object(sampleDictionary)
}
fileprivate struct Constants {
    static let scope_1_name: String = "scope_1"
}
private func log_scopeObjects() {
    // array
    let sampleArray: [Int] = [
        0,
        1,
        2,
        3
    ]
    Logger.debug
        .message("Array:",
                 scopeName: Constants.scope_1_name)
        .object(sampleArray,
                scopeName: Constants.scope_1_name)
    
    // dictionary
    let sampleDictionary: [String: String] = [
        "key_0": "value_0",
        "key_1": "value_1",
        "key_2": "value_2",
        "key_3": "value_3"
    ]
    Logger.debug
        .message("Dictionary:",
                 scopeName: Constants.scope_1_name)
        .object(sampleDictionary,
                scopeName: Constants.scope_1_name)
}

private func log_nil() {
    Logger.debug.message("Logging nil:").object(nil)
}

private func exerciseSimpleLogger() {
    log_message()
    log_objects()
    log_scopeObjects()
    log_nil()
}

fileprivate func test_writing_to_file() {
    
    guard let valid_directoryPath: String = Logger.currentDirectoryPath() else {
        let message: String = "Unable to obtain valid directory path!"
        Logger.error.message(message)
        return
    }
    let logsDirectoryPath: String = "\(valid_directoryPath)/logs"
    Logger.setLogsDirectoryPath(logsDirectoryPath)
    // Logger.setSingleLogFileName("application.log")
    // Logger.setSingleLogFileMaxSizeInBytes(1024*1024*1)
    Logger.setFileLogging(.multipleFiles)
    Logger.setPrefix(.ascii)
}

test_writing_to_file()

for _ in 0..<10 {
    exerciseSimpleLogger()
}

let messge_finish: String = "Finished Simple logger excercise!"
debugPrint("🔧 \(#file) » \(#function) » \(#line)", messge_finish, separator: "\n")
