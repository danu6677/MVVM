//
//  DispatchQueues.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation

enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}

//Api requested Content-Type
enum CONTENT_TYPE {
    case JSON_ENCODED
    case X_WWW_FORM_URLENCODED
}

//Api requested Content-Type
enum NETWORK_REQUEST_TYPES:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
