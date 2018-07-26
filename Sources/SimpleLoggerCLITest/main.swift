import Foundation
import SimpleLogger

let messge_start: String = "Starting Simple logger excercise!"
debugPrint("🔧 \(#file) » \(#function) » \(#line)", messge_start, separator: "\n")

let array: [String] = [
    "John",
    "Jane",
    "Joe"
]
debugPrint("test array: ", array, separator: "\n")

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

private func log_object() {
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

private func log_nil() {
    Logger.debug.message("Logging nil:").object(nil)
}

private func exerciseSimpleLogger() {
    log_message()
    log_object()
    log_nil()
}

exerciseSimpleLogger()

let messge_finish: String = "Finished Simple logger excercise!"
debugPrint("🔧 \(#file) » \(#function) » \(#line)", messge_finish, separator: "\n")

