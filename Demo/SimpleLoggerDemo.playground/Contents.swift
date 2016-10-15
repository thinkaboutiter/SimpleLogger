//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

Logger.enableLogging(true)
Logger.useVerbosity(.full)

Logger.general.message(str)
Logger.debug.message(str)
Logger.success.message(str)
Logger.warning.message(str)
Logger.error.message(str)
Logger.fatal.message(str)
Logger.network.message(str)
Logger.cache.message(str)


let anObject: NSObject = NSObject()

Logger.general.message("Logging a \(type(of: anObject))").object(anObject)

let anArray: [String] = ["foo", "bar", "dee"]

Logger.debug.message("Logging a \(type(of: anArray))").object(anArray)

Logger.debug.object(Optional.some(32))

let optionalInt: Int? = 4

Logger.debug.message("optionalInt: \(optionalInt)").object(optionalInt)
