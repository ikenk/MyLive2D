//
//  HTTPRequest.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/22.
//

import Foundation

struct HTTPRequest {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    let queryItem: [URLQueryItem]?

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    init(path: String, method: HTTPMethod, headers: [String: String] = [:], body: Data? = nil, queryItem: [URLQueryItem]? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.queryItem = queryItem
    }
}
