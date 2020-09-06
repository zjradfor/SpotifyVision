//
//  NetworkManager.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-19.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    case GET, POST, PUT, DELETE
}

fileprivate enum HTTPResponseStatusCode {
    case OK(Int)
    case REDIRECTION(Int)
    case ERROR(Int)
    
    init?(rawValue: Int) {
        switch rawValue / 100 {
        case 2: self = .OK(rawValue)
        case 3: self = .REDIRECTION(rawValue)
        case 4: self = .ERROR(rawValue)
        default: return nil
        }
    }
}

typealias HTTPRequestParameters = [String: Any]
typealias HTTPRequestHeaders = [String: String]

extension Dictionary where Key == String {
    var httpCompatible: String {
        return String(
            self.reduce("") { "\($0)&\($1.key)=\($1.value)" }
                .replacingOccurrences(of: " ", with: "+")
                .dropFirst()
        )
    }
}

extension URL {
    func with(parameters: String) -> URL? {
        return URL(string: "\(self.absoluteString)?\(parameters)")
    }
}

extension URLSession {
    func request(_ urlString: String,
                 method: HTTPRequestMethod = .GET,
                 parameters: HTTPRequestParameters? = nil,
                 headers: HTTPRequestHeaders? = nil,
                 completionHandler: @escaping (Result<Data, APIError>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue

        if let parameters = parameters?.httpCompatible {
            switch method {
            case .GET, .PUT, .DELETE:
                request.url = url.with(parameters: parameters)
            case .POST:
                request.httpBody = parameters.data(using: .utf8)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                let status = HTTPResponseStatusCode(rawValue: response.statusCode) else {
                return
            }
            
            switch status {
            case .OK(_):
                DispatchQueue.main.async { completionHandler(.success(data)) }
                
            case .ERROR(400):
                completionHandler(.failure(.badRequest))
                
            case .ERROR(401):
                print("needs refresh token")
                AuthorizationService().refreshToken { result in
                    if result {
                        let token: String = UserDefaults.standard.accessToken!
                        let newHeader: HTTPRequestHeaders = ["Authorization" : "Bearer \(token)"]
                        self.request(urlString, method: method, parameters: parameters, headers: newHeader) { result in
                            if case let .success(newData) = result {
                                DispatchQueue.main.async { completionHandler(.success(newData)) }
                            }
                        }
                    } else {
                        DispatchQueue.main.async { completionHandler(.failure(.generalError)) }
                    }
                }
                
            case .ERROR(403):
                completionHandler(.failure(.forbidden))
                
            case .ERROR(404):
                completionHandler(.failure(.notFound))
                
            case .ERROR(429):
                completionHandler(.failure(.tooManyRequests))
                
            default:
                // figure out what other errors happen and filter them
                DispatchQueue.main.async { completionHandler(.failure(.generalError)) }
            }
        }
        
        task.resume()
    }
}

//                do{
//                     //here dataResponse received from a network request
//                     let jsonResponse = try JSONSerialization.jsonObject(with:
//                                            data, options: [])
//                     print(jsonResponse) //Response result
//                  } catch let parsingError {
//                     print("Error", parsingError)
//                }
