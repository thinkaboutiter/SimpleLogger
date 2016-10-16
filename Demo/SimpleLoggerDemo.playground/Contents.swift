//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

Logger.enableLogging(true)
Logger.useVerbosity(.full)

// test logging a message
Logger.general.message(str)
Logger.debug.message(str)
Logger.success.message(str)
Logger.warning.message(str)
Logger.error.message(str)
Logger.fatal.message(str)
Logger.network.message(str)
Logger.cache.message(str)


// loggign an NSObject
let anObject: NSObject = NSObject()
Logger.debug.message("Logging a \(type(of: anObject))").object(anObject)


// loggign an Array
let anArray: [String] = [
    "foo",
    "bar",
    "dee"
]
Logger.debug.message("Logging a \(type(of: anArray))").object(anArray)


// logging a Dictionary
let aDictionary: [String : UIColor] = [
    "red": UIColor.red,
    "green": UIColor.green,
    "blue": UIColor.blue
]
Logger.debug.message("Logging a \(type(of: aDictionary))").object(aDictionary)


// logging Optionals
// inline optional
Logger.debug.message("Logging optional literal").object(Optional.some(32))

// Int?
let optionalInt: Int? = 4
Logger.debug.message("optionalInt: \(optionalInt)").object(optionalInt)

// String?
let optionalSting: String? = "💩"
Logger.debug.message("optionalString: \(type(of: optionalSting))").object(optionalSting)

// Float?
let optionalFoat: Float? = 0.32345
Logger.debug.message("optionalFloat: \(type(of: optionalFoat))").object(optionalFoat)


// logging nil
Logger.debug.message("Logging nil:").object(nil)
