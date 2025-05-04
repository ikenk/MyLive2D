//
//  NetworkManager.swift
//  MyLive2D-AIChat
//
//  Created by HT Zhang  on 2025/04/22.
//

import Foundation

final class NetworkManager {
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    
    static var `default`: NetworkManager = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        let serverAddress = UserDefaults.standard.string(forKey: UserDefaultsKeys.serverAddress) ?? ServerDefaults.address
        let serverPort = UserDefaults.standard.string(forKey: UserDefaultsKeys.serverPort) ?? ServerDefaults.port
        let baseURL = URL(string: "http://\(serverAddress):\(serverPort)")!
        
        return .init(session: .shared, baseURL: baseURL, decoder: decoder)
    }()

    init(session: URLSession = .shared, baseURL: URL, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.baseURL = baseURL
        self.decoder = decoder
    }

    func request(_ request: HTTPRequest) async throws -> Data {
        // 构建URL（添加查询参数）
        var components = URLComponents(url: baseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: true)
        components?.queryItems = request.queryItem
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 根据状态码处理响应
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 400:
                throw NetworkError.badRequest(httpResponse.statusCode,data)
            case 401:
                throw NetworkError.unauthorized(httpResponse.statusCode,data)
            case 403:
                throw NetworkError.forbidden(httpResponse.statusCode,data)
            case 404:
                throw NetworkError.notFound(httpResponse.statusCode,data)
            case 400...499:
                throw NetworkError.clientError(httpResponse.statusCode, data)
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode, data)
            default:
                throw NetworkError.clientError(httpResponse.statusCode, data)
            }
        } catch let error as URLError {
            throw NetworkError(urlError: error)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    func request<T: Decodable>(_ request: HTTPRequest) async throws -> T {
        let data = try await self.request(request)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
