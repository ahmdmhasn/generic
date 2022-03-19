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
        let path = "me"
        let request = RemoteRequest(apiVersion: .none, method: .get, path: path)
        let mapper = AccountMapper()

        enqueue(request, mapper: mapper, completion: completion)
    }
}
