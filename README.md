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
2. (Optional) Configure verbosity - UInt32 value so it can be grouped with bitwise OR (|)
    `Logger.use_verbosity(.all.rawValue)`
3. (Optional) Configure delimiter (`»` by default)
    `Logger.use_delimiter(">")`
4. (Optional) Configure logging file path (enabled by default)
    `Logger.set_shouldLogFilePathPrefix(true)`
5. (Optional) Configure emoji or ascii prefix (`.emoji` by default)
6. Write logs to disk:
    - Using single log file
        - specifying maximum file size.
    - Using multiple log files
        - log files created are after the name of the files the log is invoked in.
7. And more...

# How to use
1. Log message
    `Logger.debug.message("Some message to log")`
2. Log message and object (methods are chainable)
    `Logger.debug.message("Some message to log").object(someObjectToDebug)`
3. Check out sample project included.
4. *nix OS compatible.
