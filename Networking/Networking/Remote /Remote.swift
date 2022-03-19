import Combine
import Foundation
import protocol Alamofire.URLRequestConvertible

/// Represents a collection of Remote Endpoints
///
public class Remote {
    
    /// Networking Wrapper: Dependency Injection Mechanism, useful for Unit Testing purposes.
    ///
    let network: Network
    
    
    /// Designated Initializer.
    ///
    /// - Parameters:
    ///     - credentials: Credentials to be used in order to authenticate every request.
    ///     - network: Network Wrapper, in charge of actually enqueueing a given network request.
    ///
    public init(network: Network) {
        self.network = network
    }
    
    
    /// Enqueues the specified Network Request.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - completion: Closure to be executed upon completion. Will receive the JSON Parsed Response (if successful)
    ///
    func enqueue<T>(_ request: URLRequestConvertible, completion: @escaping (Result<T?, Error>) -> Void) {
        network.responseData(for: request) { [weak self] result in
            guard let self = self else {
                return
            }
            
            do {
                let data = try result.get()
                
                if let remoteError = RemoteValidator.error(from: data) {
                    self.remoteErrorWasReceived(error: remoteError, for: request)
                    completion(.failure(remoteError))
                    return
                }
                
                let document = try JSONSerialization.jsonObject(with: data, options: [])
                guard let value = document as? T else {
                    LogError("<> Serialization Error: \(request)")
                    completion(.failure(NetworkError.notFound))
                    return
                }
                
                completion(.success(value))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Enqueues the specified Network Request.
    ///
    /// - Important:
    ///     - Parsing will be performed by the Mapper.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - mapper: Mapper entity that will be used to attempt to parse the Backend's Response.
    ///     - completion: Closure to be executed upon completion.
    ///
    func enqueue<M: Mapper>(_ request: URLRequestConvertible, mapper: M,
                            completion: @escaping (Result<M.Output, Error>) -> Void) {
        network.responseData(for: request) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                if let remoteError = RemoteValidator.error(from: data) {
                    self.remoteErrorWasReceived(error: remoteError, for: request)
                    completion(.failure(remoteError))
                    return
                }
                
                do {
                    let parsed = try mapper.map(response: data)
                    completion(.success(parsed))
                } catch {
                    LogError("<> Mapping Error: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Returns a publisher that enqueues the specified Network Request on subscription and emits the result upon completion.
    ///
    /// - Important:
    ///     - Parsing will be performed by the Mapper.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - mapper: Mapper entity that will be used to attempt to parse the Backend's Response.
    ///
    /// - Returns: A publisher that emits result upon completion.
    @available(iOS 13.0, *)
    func enqueue<M: Mapper>(_ request: URLRequestConvertible, mapper: M) -> AnyPublisher<Result<M.Output, Error>, Never> {
        network.responseDataPublisher(for: request)
            .map { result in
                switch result {
                case .success(let data):
                    if let remoteError = RemoteValidator.error(from: data) {
                        return .failure(remoteError)
                    }
                    
                    do {
                        let parsed = try mapper.map(response: data)
                        return .success(parsed)
                    } catch {
                        LogError("<> Mapping Error: \(error)")
                        return .failure(error)
                    }
                case .failure(let error):
                    return .failure(error)
                }
            }
            .handleEvents(receiveOutput: { [weak self] result in
                if let remoteError = result.failure as? RemoteError {
                    self?.remoteErrorWasReceived(error: remoteError, for: request)
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Enqueues the specified Network Request for upload with multipart form data encoding.
    ///
    /// - Important:
    ///     - Parsing will be performed by the Mapper.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - mapper: Mapper entitity that will be used to attempt to parse the Backend's Response.
    ///     - multipartFormData: Used for appending data for multipart form data uploads.
    ///     - completion: Closure to be executed upon completion.
    ///
    func enqueueMultipartFormDataUpload<M: Mapper>(_ request: URLRequestConvertible,
                                                   mapper: M,
                                                   multipartFormData: @escaping (MultipartFormData) -> Void,
                                                   completion: @escaping (Result<M.Output, Error>) -> Void) {
        network.uploadMultipartFormData(multipartFormData: multipartFormData,
                                        to: request) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(NetworkError.notFound))
                    return
                }
                
                if let remoteError = RemoteValidator.error(from: data) {
                    self.remoteErrorWasReceived(error: remoteError, for: request)
                    completion(.failure(remoteError))
                    return
                }
                
                do {
                    let parsed = try mapper.map(response: data)
                    completion(.success(parsed))
                } catch {
                    LogError("<> Mapping Error: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private Methods
//
private extension Remote {
    
    /// Handles *all* of the DotcomError(s) that are successfully parsed.
    ///
    func remoteErrorWasReceived(error: Error, for request: URLRequestConvertible) {
        guard let remoteError = error as? RemoteError else {
            return
        }
        
        switch remoteError {
        case .invalidToken:
            publishInvalidTokenNotification(error: remoteError)
        default:
            break
        }
    }
    
    
    /// Publishes an `Invalid Token` Notification.
    ///
    private func publishInvalidTokenNotification(error: RemoteError) {
        NotificationCenter.default.post(name: .RemoteDidReceiveInvalidTokenError, object: error, userInfo: nil)
    }
}

// MARK: - Constants!
//
public extension Remote {
    
    enum Default {
        public static let firstPageNumber: Int = 1
    }
}


// MARK: - Remote Notifications
//
public extension NSNotification.Name {
    
    /// Posted whenever an Invalid Token Error is received.
    ///
    static let RemoteDidReceiveInvalidTokenError = NSNotification.Name(rawValue: "RemoteDidReceiveInvalidTokenError")
}
