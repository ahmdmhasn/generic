//
//  LoggingMethods.swift
//  Logging
//
//  Created by Ahmed M. Hassan on 04/03/2022.
//

import ShipBookSDK

/// Log Debug
///
public func LogDebug(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       tag: String? = nil) {

    Log.d(message(),
          tag: tag,
          function: function,
          file: file,
          line: line)
}

/// Log Info
///
public func LogInfo(_ message: @autoclosure () -> String,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line,
                    tag: String? = nil) {

    Log.i(message(),
          tag: tag,
          function: function,
          file: file,
          line: line)
}

/// Log Warn
///
public func LogWarn(_ message: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line,
                      tag: String? = nil) {

    Log.w(message(),
          tag: tag,
          function: function,
          file: file,
          line: line)
}

/// Log Verbose
///
public func LogVerbose(_ message: @autoclosure () -> String,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         tag: String? = nil) {

    Log.v(message(),
          tag: tag,
          function: function,
          file: file,
          line: line)
}

/// Log Error
///
public func LogError(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       tag: String? = nil) {

    Log.e(message(),
          tag: tag,
          function: function,
          file: file,
          line: line)
}
