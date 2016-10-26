//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// enable logging
Logger.enableLogging(true)

// setup verbosity
Logger.useVerbosity(.full)

// disable location prefix (since we are in a playground it does not make much help)
Logger.enableSourceLocationPrefix(false)

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
Logger.debug.message("Logging: \(type(of: anObject))").object(anObject)


// loggign an Array
let anArray: [String] = [
    "foo",
    "bar",
    "dee"
]
Logger.debug.message("Logging: \(type(of: anArray))").object(anArray)


// logging a Dictionary
let aDictionary: [String : UIColor] = [
    "red": UIColor.red,
    "green": UIColor.green,
    "blue": UIColor.blue
]
Logger.debug.message("Logging: \(type(of: aDictionary))").object(aDictionary)


// logging Optionals
// inline optional
Logger.debug.message("Logging: optional literal").object(Optional.some(32))

// Int?
let optionalInt: Int? = 4
Logger.debug.message("Logging: \(type(of:optionalInt))").object(optionalInt)

// String?
let optionalSting: String? = "💩"
Logger.debug.message("Logging: \(type(of: optionalSting))").object(optionalSting)

// Float?
let optionalFoat: Float? = 0.32345
Logger.debug.message("Logging: \(type(of: optionalFoat))").object(optionalFoat)


// logging nil
Logger.debug.message("Logging: nil").object(nil)
