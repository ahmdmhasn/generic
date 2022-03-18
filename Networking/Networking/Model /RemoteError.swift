// TODO: Update cases per remote errors
import Foundation

/// Remote Request Error
///
public enum RemoteError: Error, Decodable, Equatable {

    /// Non explicit reason
    ///
    case empty

    /// Missing Token!
    ///
    case unauthorized

    /// We're not properly authenticated
    ///
    case invalidToken

    ///
    case unknown(code: String, message: String?)

    /// Decodable Initializer.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.decode(String.self, forKey: .error)
        let message = try container.decodeIfPresent(String.self, forKey: .message)

        switch error {
        case Constants.invalidToken:
            self = .invalidToken
        case Constants.unauthorized:
            self = .unauthorized
        default:
            self = .unknown(code: error, message: message)
        }
    }

    /// Constants for Possible Error Identifiers
    ///
    private enum Constants {
        static let unauthorized     = "unauthorized"
        static let invalidToken     = "invalid_token"
    }

    /// Coding Keys
    ///
    private enum CodingKeys: String, CodingKey {
        case error
        case message
    }
}


// MARK: - CustomStringConvertible Conformance
//
extension RemoteError: CustomStringConvertible {

    public var description: String {
        switch self {
        case .empty:
            return NSLocalizedString("Remote Response Empty", comment: "Error thrown when the response body is empty")
        case .invalidToken:
            return NSLocalizedString("Remote Token Invalid", comment: "Invalid Token")
        case .unauthorized:
            return NSLocalizedString("Remote Missing Token", comment: "Missing Token")
        case .unknown(let code, let message):
            let theMessage = message ?? String()
            let messageFormat = NSLocalizedString(
                "Remote Error: [%1$@] %2$@",
                comment: "(unmapped!) error. Parameters: %1$@ - code, %2$@ - message"
            )
            return String.localizedStringWithFormat(messageFormat, code, theMessage)
        }
    }
}


// MARK: - Equatable Conformance
//
public func ==(lhs: RemoteError, rhs: RemoteError) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty):
        return true
    case (.unauthorized, .unauthorized):
        return true
    case (.invalidToken, .invalidToken):
        return true
    case let (.unknown(codeLHS, _), .unknown(codeRHS, _)):
        return codeLHS == codeRHS
    default:
        return false
    }
}
