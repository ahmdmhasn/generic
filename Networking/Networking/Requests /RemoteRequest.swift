import Foundation
import Alamofire


/// Represents a Remote Request
///
struct RemoteRequest: URLRequestConvertible {

    /// Remote API Version
    ///
    let apiVersion: APIVersion

    /// HTTP Request Method
    ///
    let method: HTTPMethod

    /// RPC
    ///
    let path: String

    /// Parameters
    ///
    let parameters: [String: Any]?


    /// Designated Initializer.
    ///
    /// - Parameters:
    ///     - apiVersion: Endpoint Version.
    ///     - method: HTTP Method we should use.
    ///     - path: RPC that should be executed.
    ///     - parameters: Collection of String parameters to be passed over to our target RPC.
    ///
    init(apiVersion: APIVersion, method: HTTPMethod, path: String, parameters: [String: Any]? = nil) {
        self.apiVersion = apiVersion
        self.method = method
        self.path = path
        self.parameters = parameters ?? [:]
    }

    /// Returns a URLRequest instance representing the current remote Request.
    ///
    func asURLRequest() throws -> URLRequest {
        let uRL = URL(string: Settings.baseURL + apiVersion.path + path)!
        let request = try URLRequest(url: uRL, method: method, headers: nil)

        return try URLEncoding.default.encode(request, with: parameters)
    }
}
