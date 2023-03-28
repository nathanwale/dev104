//
//  ApiRequest.swift
//  Habits
//
//  Created by Nathan Wale on 25/1/2023.
//

import Foundation

//
// Protocol for an API Request
//  - path: path to endpoint, excludes domain and query string
//  - queryItems: optional list of query items
//  - request: request as URLRequest
//  - postData: optional data to post in a POST request
//
protocol ApiRequest
{
    // type of response
    associatedtype Response
    
    // path to endpoint, excludes domain and query string
    var path: String { get }
    
    // optional list of query items
    var queryItems: [URLQueryItem]? { get }
    
    // request as URLRequest
    var request: URLRequest { get }
    
    // optional data to post in a POST request
    var postData: Data? { get }
}


//
// Error returned on bad API Requests
//  - notFound: There's nothing at this location
//  - requestFailed: The request failed, probably for an unknown reason
//  - badResponse: HTTP response code was not 200 OK.
//        statusCode is the response code returned
//
enum ApiRequestError: Error
{
    case notFound
    case requestFailed
    case badResponse(statusCode: Int)
}


//
// Configure ApiRequest for this service
//
extension ApiRequest
{
    var host: String { "localhost" }
    var port: Int { 8080 }
}


//
// Defaults for ApiRequest
//
extension ApiRequest
{
    var queryItems: [URLQueryItem]? { nil }
    var postData: Data? { nil }
}


//
// `request` implementation for ApiRequest
//
extension ApiRequest
{
    var request: URLRequest
    {
        // build URL components
        var components = URLComponents()
        
        components.scheme = "http"
        components.host = host
        components.port = port
        components.path = path
        components.queryItems = queryItems
        
        // assign url components to request
        var request = URLRequest(url: components.url!)
        
        // if we have POST data, add it to the request
        if let data = postData {
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
        }
        
        return request
    }
}


//
// `post()` implementation for ApiRequest
//  - post data to server
//  - throws ApiRequestError
//  - is async
//
extension ApiRequest
{
    func post() async throws
    {
        // send request, ignore data payload
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // ensure response is valid HTTP, else throw error
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiRequestError.requestFailed
        }

        // ensure HTTP status code is 200 (OK), else throw error
        if httpResponse.statusCode != 200 {
            throw ApiRequestError.badResponse(statusCode: httpResponse.statusCode)
        }
    }
}


//
// `send()` implementation for ApiRequest
//  - returns Response type
//  - post data to server
//  - throws ApiRequestError
//  - is async
//
extension ApiRequest where Response: Decodable
{
    func send() async throws -> Response
    {
        // send request, assign data and response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // ensure response is valid HTTP, else throw error
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiRequestError.requestFailed
        }

        // ensure HTTP status code is 200 (OK), else throw error
        if httpResponse.statusCode != 200 {
            throw ApiRequestError.badResponse(statusCode: httpResponse.statusCode)
        }
        
        // decode response into JSON an return decoded object as Response type
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Response.self, from: data)
        
        return decoded
    }
}
