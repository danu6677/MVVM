//
//  AlertMessages.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
struct AlertMerssage{
    // MARK: - Alert Messages
    static let INTERNET_OFFLINE_MESSAGE = "Internet connection appears to be offline. Reload to try again when connection is available!"
    static let INTERNET_ONLINE_MESSAGE = "Internet connection is back online!. If you do see any data please reload."
    static let SERVER_ERROR_MESSAGE = "We are unable to download the news details. Please make sure your device is connected to the Internet and have a strong connection"
    static let SERVER_ERROR_MESSAGE_500 = "News server is down at the moment, please try again later."
    static let INTERNAL_ERROR = "We are experiencing an internal error at the moment."
    static let REQUEST_JSON_BODY_SERIALIZATION_ERROR_MESSAGE = "Experienced an error in JSON request body serialization!"
    static let RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE = "Experienced an error in JSON response de-serialization!"
    static let UNKNOWN_ERROR_MESSAGE = "Some unexpected error occured! Please try again later"
    static let UNAUTHORIZED_ERROR_MESSAGE = "Unauthorized access!"
    static let FORBIDDEN_ERROR_MESSAGE = "You dont ahve permission to access this content"
    static let CORE_DATA_ERROR = "Core Data Error" 
}
