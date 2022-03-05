//
//  Logging.swift
//  Generic
//
//  Created by Ahmed M. Hassan on 05/03/2022.
//

import Logging

/// Instead of import logging in each file, this should provide a gate for logging method.
/// This should not have any performance issue since inline will bypass this.

/// Log Debug
///
internal func LogDebug(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       tag: String? = nil) {
    
    Logging.LogDebug(message(),
                     file: file,
                     function: function,
                     line: line,
                     tag: tag)
}

/// Log Info
///
internal func LogInfo(_ message: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line,
                      tag: String? = nil) {
    
    Logging.LogInfo(message(),
                    file: file,
                    function: function,
                    line: line,
                    tag: tag)
}

/// Log Warn
///
internal func LogWarn(_ message: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line,
                      tag: String? = nil) {
    
    Logging.LogWarn(message(),
                    file: file,
                    function: function,
                    line: line,
                    tag: tag)
}

/// Log Verbose
///
internal func LogVerbose(_ message: @autoclosure () -> String,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         tag: String? = nil) {
    
    Logging.LogVerbose(message(),
                       file: file,
                       function: function,
                       line: line,
                       tag: tag)
}

/// Log Error
///
internal func LogError(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       tag: String? = nil) {
    
    Logging.LogError(message(),
                     file: file,
                     function: function,
                     line: line,
                     tag: tag)
}
