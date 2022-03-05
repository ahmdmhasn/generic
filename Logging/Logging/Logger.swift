//
//  Logger.swift
//  Logger
//
//  Created by Ahmed M. Hassan on 04/03/2022.
//

import ShipBookSDK

/// Logger
///
public class Logger {

    /// Starts the logging SDK. Should be called in application(_:didFinishLaunchingWithOptions:)
    ///
    public static func configure() {
        ShipBook.start(appId: Credentials.appId, appKey: Credentials.appKey)
    }
}
