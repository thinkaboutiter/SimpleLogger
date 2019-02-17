//
//  LogWriter.swift
//  SimpleLogger
//
//  Created by Boyan Yankov on W06 08/Feb/2019 Fri.
//

import Foundation

protocol LogWriter {
    static func update_logsDirectoryPath(_ newValue: String)
    static func currentDirectoryPath(from candidate: String) -> String?
}
