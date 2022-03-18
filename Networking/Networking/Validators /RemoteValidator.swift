import Foundation


/// Remote Response Validator
///
struct RemoteValidator {
    
    /// Returns the RemoteError contained in a given Data Instance (if any).
    ///
    static func error(from response: Data) -> Error? {
        return try? JSONDecoder().decode(RemoteError.self, from: response)
    }
}
