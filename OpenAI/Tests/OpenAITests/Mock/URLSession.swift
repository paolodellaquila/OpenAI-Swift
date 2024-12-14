//
//  UrlManager.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

class URLSessionMock: URLSession, @unchecked Sendable {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock { [weak self] in
            completionHandler(self?.data, self?.response, self?.error)
        }
    }
}
