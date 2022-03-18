import Foundation


/// Authenticated Requests Credentials
///
public struct Credentials: Equatable {

    /// Remote Username
    ///
    public let username: String

    /// Remote Authentication Token
    ///
    public let authToken: String

    /// Designated Initializer
    ///
    public init(username: String, authToken: String) {
        self.username = username
        self.authToken = authToken
    }

    /// Convenience initializer. Assigns a UUID as a placeholder for the username.
    ///
    public init(authToken: String) {
        self.init(username: UUID().uuidString, authToken: authToken)
    }

    /// Returns true if the username is a UUID placeholder.
    ///
    public func hasPlaceholderUsername() -> Bool {
        return UUID(uuidString: username) != nil
    }
}
