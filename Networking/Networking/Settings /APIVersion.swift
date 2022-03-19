import Foundation


/// Defines the supported API Versions.
///
public enum APIVersion: String {

    /// No version
    ///
    case none = ""

    /// Endpoint Mark 1
    ///
    case mark1 = "v1"
    

    /// Returns the path for the current API Version
    ///
    var path: String {
        guard self != .none else {
            return "/"
        }

        return "/" + rawValue + "/"
    }
}
