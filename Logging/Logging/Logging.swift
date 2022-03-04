//
//  Logging.swift
//  Logging
//
//  Created by Ahmed M. Hassan on 04/03/2022.
//

import ShipBookSDK

/// Logging
///
public class Logging {

    /// Starts the logging SDK. Should be called in application(_:didFinishLaunchingWithOptions:)
    ///
    public static func configure() {
        ShipBook.start(appId: Credentials.appId, appKey: Credentials.appKey)
    }
}
