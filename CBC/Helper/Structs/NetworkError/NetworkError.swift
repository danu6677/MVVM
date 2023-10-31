//
//  NetworkErrors.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
struct NetworkError{
    // MARK: - Network status codes/error codes
    static let ERROR_CODE_REQUEST_TIMEOUT = -1001
    static let ERROR_CODE_NETWORK_CONNECTION_LOST = -1005
    static let ERROR_CODE_INTERNET_OFFLINE = -1009
    static let STATUS_CODE_REQUEST_SUCCESS = 200
    static let STATUS_CODE_REQUEST_SUCCESS_RANGE = 200...299
    static let STATUS_CODE_FORBIDDEN = 403
    static let STATUS_CODE_UNAUTHORIZED = 401
    static let STATUS_CODE_BAD_REQUEST = 400
    static let STATUS_CODE_SERVER_ERROR = 500
    static let STATUS_CODE_SERVER_ERROR_RANGE = 500...599
    static let STATUS_CODE_SERVER_GATEWAY_TIMEOUT = 504

}
