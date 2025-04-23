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
    
//    static let shared: NetworkManager = {
//        // 从UserDefaults读取服务器设置
//        let serverAddress = UserDefaults.standard.string(forKey: "serverAddress") ?? "127.0.0.1"
//        let serverPort = UserDefaults.standard.string(forKey: "serverPort") ?? "1234"
//        let urlString = "http://\(serverAddress):\(serverPort)"
//        
//        guard let url = URL(string: urlString) else {
//            fatalError("无效的服务器地址")
//        }
//        
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
//        
//        return NetworkManager(session: session, baseURL: url)
//    }()

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
                throw NetworkError.badRequest(data)
            case 401:
                throw NetworkError.unauthorized(data)
            case 403:
                throw NetworkError.forbidden(data)
            case 404:
                throw NetworkError.notFound(data)
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
