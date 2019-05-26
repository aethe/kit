// MIT License
//
// Copyright (c) 2019 Andrey Ufimtsev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import os

/// A log in the unified logging system.
struct Log {
    /// The system log associated with the log.
    private let systemLog: OSLog
    
    /// Creates a new log with the specified category.
    ///
    /// - Parameter category: The category associated with the messages written to this log.
    private init(category: String) {
        systemLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
    
    /// Writes a message with the debug type to the log. Use this method for messages that might be helpful during development.
    ///
    /// - Parameters:
    ///   - message: A log message represented by a constant string or format string.
    ///   - arguments: Arguments if the message is a format string.
    func debug(_ message: StaticString, _ arguments: CVarArg...) {
        os_log(message, log: systemLog, type: .debug, arguments)
    }
    
    /// Writes a message with the info type to the log. Use this method for messages that might be helpful for troubleshooting errors.
    ///
    /// - Parameters:
    ///   - message: A log message represented by a constant string or format string.
    ///   - arguments: Arguments if the message is a format string.
    func info(_ message: StaticString, _ arguments: CVarArg...) {
        os_log(message, log: systemLog, type: .info, arguments)
    }
    
    /// Writes a message with the default type to the log. Use this method for messages that contain information about problems caused by the user or external services.
    ///
    /// - Parameters:
    ///   - message: A log message represented by a constant string or format string.
    ///   - arguments: Arguments if the message is a format string.
    func warning(_ message: StaticString, _ arguments: CVarArg...) {
        os_log(message, log: systemLog, type: .default, arguments)
    }
    
    /// Writes a message with the error type to the log. Use this method for messages that contain information about problems caused by the application.
    ///
    /// - Parameters:
    ///   - message: A log message represented by a constant string or format string.
    ///   - arguments: Arguments if the message is a format string.
    func error(_ message: StaticString, _ arguments: CVarArg...) {
        os_log(message, log: systemLog, type: .error, arguments)
    }
    
    /// Writes a message with the fault type to the log. Use this method for messages that contain information about problems caused by the operating system or hardware.
    ///
    /// - Parameters:
    ///   - message: A log message represented by a constant string or format string.
    ///   - arguments: Arguments if the message is a format string.
    func fault(_ message: StaticString, _ arguments: CVarArg...) {
        os_log(message, log: systemLog, type: .fault, arguments)
    }
}
