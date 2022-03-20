import Combine
import Foundation
import Alamofire


extension Alamofire.MultipartFormData: MultipartFormData { }

/// AlamofireWrapper: Encapsulates all of the Alamofire OP's
///
public class AlamofireNetwork: Network {

    private let backgroundSessionManager: Alamofire.Session

    /// Remote Credentials.
    ///
    private let credentials: Credentials


    /// Public Initializer
    ///
    public required init(credentials: Credentials) {
        self.credentials = credentials

        // A unique ID is included in the background session identifier so that the session does not get invalidated when the initializer is called multiple
        // times (e.g. when logging in).
        let uniqueID = UUID().uuidString
        
        let queue = DispatchQueue(label: "com.generic.backgroundsession.\(uniqueID)")
        self.backgroundSessionManager = Alamofire.Session(rootQueue: queue)
    }

    /// Executes the specified Network Request. Upon completion, the payload will be sent back to the caller as a Data instance.
    ///
    /// - Important:
    ///     - Authentication Headers will be injected, based on the Network's Credentials.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func responseData(for request: URLRequestConvertible,
                             completion: @escaping (Result<Data, Error>) -> Void) {
        let authenticated = AuthenticatedRequest(credentials: credentials, request: request)
        
        AF.request(authenticated).responseData { response in
            completion(response.result.toSwiftResult())
        }
    }
    
    /// Executes the specified Network Request. Upon completion, the payload or error will be emitted to the publisher.
    /// Only one value will be emitted and the request cannot be retried.
    ///
    /// - Important:
    ///     - Authentication Headers will be injected, based on the Network's Credentials.
    ///
    /// - Parameter request: Request that should be performed.
    /// - Returns: A publisher that emits the result of the given request.
    ///
    @available(iOS 13.0, *)
    public func responseDataPublisher(for request: URLRequestConvertible) -> AnyPublisher<Result<Data, Error>, Never> {
        let authenticated = AuthenticatedRequest(credentials: credentials, request: request)

        return Future { promise in
            AF.request(authenticated).responseData { response in
                let result = response.result.toSwiftResult()
                promise(.success(result))
            }
        }.eraseToAnyPublisher()
    }
    
    public func uploadMultipartFormData(multipartFormData: @escaping (MultipartFormData) -> Void,
                                        to request: URLRequestConvertible,
                                        completion: @escaping (Result<Data?, Error>) -> Void) {
        let authenticated = AuthenticatedRequest(credentials: credentials, request: request)
        
        backgroundSessionManager.upload(multipartFormData: multipartFormData, with: authenticated)
            .response { response in
                completion(response.result.toSwiftResult())
            }
    }

}

// MARK: - Alamofire.DataResponse: Private Methods
//
private extension Alamofire.DataResponse {

    /// Returns the Networking Layer Error (if any):
    ///
    ///     -   Whenever the statusCode is not within the [200, 300) range.
    ///     -   Whenever there's a `NSURLErrorDomain` error: Bad Certificate, Unreachable, Cancelled (and few others!)
    ///
    /// NOTE: that we're not doing the standard Alamofire Validation, because the stock routine, on error, will never relay
    /// back the response body. And since the Jetpack Tunneling API does not relay the proper statusCodes, we're left in
    /// the dark.
    ///
    /// Precisely: Request Timeout should be a 408, but we just get a 400, with the details in the response's body.
    ///
    var networkingError: Error? {

        // Passthru URL Errors: These are right there, even without calling Alamofire's validation.
        if let error = error as NSError?, error.domain == NSURLErrorDomain {
            return error
        }

        return response.flatMap { response in
            NetworkError(from: response.statusCode)
        }
    }
}

// MARK: - Swift.Result Conversion
private extension Alamofire.AFResult {
    /// Convert this `Alamofire.AFResult` to a `Swift.Result`.
    ///
    func toSwiftResult() -> Result<Success, Error> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
