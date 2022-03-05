//
//  ServiceLocator.swift
//  Generic
//
//  Created by Ahmed M. Hassan on 05/03/2022.
//

import Foundation

/// Provides global dependencies.
///
class ServiceLocator {

    // MARK: - Private properties

    /// ImageService
    ///
    private static var _imageService: ImageService = DefaultImageService()

    // MARK: - Getters

    /// Provides the access point to the image service.
    /// - Returns: An implementation of the ImageService protocol. It defaults to DefaultImageService
    static var imageService: ImageService {
        return _imageService
    }
}
