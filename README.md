# SimpleLogger
Simple logging tool

# How to Install
1. Add it as private pod to your `Podfile` specifying the `git` source and coresponding `tag`.
Example:
`pod "SimpleLogger", :git => "https://github.com/thinkaboutiter/SimpleLogger.git", :tag => "1.1.3"`
2. Use it as a swift package in your project.

# How to Configure
1. Enable logging (the TypeAlias `Logger` can be used instead of `SimpleLogger`)
    `Logger.enableLogging(true)`
2. (Optional) Configure verbosity (`.full` by default)
    `Logger.useVerbosity(.full)`
3. (Optional) Configure delimiter (`»` by default)
    `Logger.useDelimiter("»")`
4. (Optional) Configure source location path (enabled by default)
    `Logger.enableSourceLocationPrefix(true)`
5. Write logs to disk:
    5.1. Using single log file
        - specifying maximum file size.
    5.2. Using multiple log files
        - log files created are after the name of the files the log is invoked in.

# How to use
1. Log message
    `Logger.debug.message("Some message to log")`
2. Log message and object (methods are chain-able)
    `Logger.debug.message("Some message to log").object(someObjectToDebug)`
3. Check out sample project included.
4. *nix OS compatible.
