import Foundation

/// Protocol for `AccountRemote` mainly used for mocking.
///
/// The required methods are intentionally incomplete. Feel free to add the other ones.
///
public protocol AccountRemoteProtocol {
    func loadAccount(completion: @escaping (Result<Account, Error>) -> Void)
}


/// Account: Remote Endpoints
///
public class AccountRemote: Remote, AccountRemoteProtocol {

    /// Loads the Account Details associated with the Credential's authToken.
    ///
    public func loadAccount(completion: @escaping (Result<Account, Error>) -> Void) {
        let path = "2a473e97-102e-4f22-89c0-d2bd0a7f0387"
        let request = RemoteRequest(apiVersion: .mark3, method: .get, path: path)
        let mapper = AccountMapper()

        enqueue(request, mapper: mapper, completion: completion)
    }
}
