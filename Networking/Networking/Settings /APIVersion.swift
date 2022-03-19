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
    
    /// Endpoint Mark 2
    ///
    case mark2 = "v2"
    
    /// Endpoint Mark 3
    ///
    case mark3 = "v3"

    /// Returns the path for the current API Version
    ///
    var path: String {
        guard self != .none else {
            return "/"
        }

        return "/" + rawValue + "/"
    }
}
