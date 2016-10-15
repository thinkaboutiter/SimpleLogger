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
