# SimpleLogger
Simple logging tool

# How to Install
1. Add CocoaPods specs source to your pod file
    `source "https://github.com/CocoaPods/Specs.git"`
2. Add also SimpleLogger specs source to your pod file
    `source "https://github.com/thinkaboutiter/SimpleLogger.git"`
3. Add as pod dependency
    `pod "SimpleLogger"`

# How to Configure
1. Enable logging (the TypeAlias `Logger` can be used instead of `SimpleLogger`)
    `Logger.enableLogging(true)`
2. (Optional) Configure verbosity (`.full` by default)
    `Logger.useVerbosity(.full)``
3. (Optional) Configure delimiter (`»` by default)
    `Logger.useDelimiter("»")`
4. (Optional) Configure source location path (enabled by default)
    `Logger.enableSourceLocationPrefix(true)`

# How to use
1. Log message
    `Logger.debug.message("Some message to log")`
2. Log message and object (methods are chain-able)
    `Logger.debug.message("Some message to log").object(someObjectToDebug)`
