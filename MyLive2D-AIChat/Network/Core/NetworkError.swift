//
//  NetworkError.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/10.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    // HTTP状态码相关错误
    case badRequest(Data?) // 400
    case unauthorized(Data?) // 401
    case forbidden(Data?) // 403
    case notFound(Data?) // 404
    case clientError(Int, Data?) // 其他4xx
    case serverError(Int, Data?) // 5xx

    // 连接错误
    case timeout // 连接超时
    case noInternet // 无网络连接
    case dnsFailure // DNS解析失败
    case connectionLost // 连接中断

    // 数据处理错误
    case invalidURL // URL无效
    case invalidResponse // 响应格式无效
    case decodingError(Error) // 解码失败
    case noData // 无数据

    // 其他错误
    case cancelled // 请求取消
    case unknown(Error) // 未知错误

    // 从URLError映射
    init(urlError: URLError) {
        switch urlError.code {
        case .timedOut:
            self = .timeout
        case .notConnectedToInternet:
            self = .noInternet
        case .cannotFindHost, .dnsLookupFailed:
            self = .dnsFailure
        case .networkConnectionLost:
            self = .connectionLost
        case .cancelled:
            self = .cancelled
        case .badURL, .unsupportedURL:
            self = .invalidURL
        default:
            self = .unknown(urlError)
        }
    }

    // 可本地化的错误描述
    var errorDescription: String? {
        switch self {
        // HTTP状态码相关错误
        case .badRequest:
            return "请求参数错误"
        case .unauthorized:
            return "需要身份验证"
        case .forbidden:
            return "没有访问权限"
        case .notFound:
            return "请求的资源不存在"
        case .clientError(let code, _):
            return "客户端错误: \(code)"
        case .serverError(let code, _):
            return "服务器错误: \(code)"
        // 连接错误
        case .timeout:
            return "请求超时，请检查网络连接"
        case .noInternet:
            return "无网络连接，请检查您的网络设置"
        case .dnsFailure:
            return "无法解析服务器地址"
        case .connectionLost:
            return "网络连接中断"
        // 数据处理错误
        case .invalidURL:
            return "无效的URL"
        case .invalidResponse:
            return "无效的响应格式"
        case .decodingError(let error):
            return "数据解析错误: \(error.localizedDescription)"
        case .noData:
            return "没有接收到数据"
        // 其他错误
        case .cancelled:
            return "请求已取消"
        case .unknown(let error):
            return "未知错误: \(error.localizedDescription)"
        }
    }

    // 用于调试的详细错误信息
    var failureReason: String? {
        switch self {
        case .decodingError(let error):
            return "解码错误详情: \(error)"
        case .clientError(let code, _), .serverError(let code, _):
            return "HTTP状态码: \(code)"
        case .unknown(let error):
            return "\(error)"
        default:
            return nil
        }
    }
}
