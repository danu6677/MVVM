//
//  Network.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-09-30.
//

import Foundation

final class Network: NSObject {
    
    ///Singleton
    private static var networkCalls: Network?
    private override init() {}

    public static var shared: Network {

        if networkCalls == nil {
            networkCalls = Network()
        }
        return networkCalls!

    }
    
    /******Class Properties*****/
     typealias SuccessBlock = (Any) -> Void
     typealias FailureBlock = (_ errorCode: Int, _ error: String,_ allHeaders: [AnyHashable : Any]?) -> Void
    //Network resquest Responce structures
     private let RESPONSE_STRUCTURE = (C:"Codable_Object", O: "Other_Forms")
    
    //Set Network Configurations
    fileprivate lazy var configurationManager: URLSession = {
       let configuration = URLSessionConfiguration.default
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 1200
        configuration.timeoutIntervalForResource = 600
        configuration.httpMaximumConnectionsPerHost = 600

        let manager = URLSession(configuration: configuration)
        return manager

    }()

   
    /****Generic Request***/
    fileprivate func performWebServiceRequest <T: Codable, K:Codable>(type: T.Type, with url: URL, contentType: CONTENT_TYPE? = nil, requestType: String, paramData: T? = nil, requestOptions: [String: String]?, responseStructure: String, successBlock: @escaping SuccessBlock, failureBlock: @escaping FailureBlock,return_response:K.Type? = nil) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = requestType // "POST", "GET", "PUT" or "DELETE"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        switch contentType {
        case .JSON_ENCODED:
                request.httpBody = try? JSONEncoder().encode(paramData)
        case .X_WWW_FORM_URLENCODED:
                request.httpBody = paramData?.dictionary.queryString
        case .none:
                break
        }

        //Addinhg Auth/secret-key/application-id and etc or application/json", forHTTPHeaderField: "Accept
        if requestOptions != nil {
            for (key, value) in requestOptions! {
                request.addValue(value, forHTTPHeaderField: key)
            }
            //add the authorization token to header if available
            /*if let token = KeychainWrapper.standard.string(forKey: Constants.TOKEN) {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }*/
        }

        let task = configurationManager.dataTask(with: request as URLRequest) { (data, response, error) in
            // var allHeader
            var headers: [AnyHashable : Any]? {
                if let httpResponse = response as? HTTPURLResponse {
                   let headers = httpResponse.allHeaderFields
                    return headers
                }
                return nil
            }
            
            guard let data: Data = data, let response: URLResponse = response, error == nil else {
        

                // Handling Network unavailability
                if (error! as NSError).code == NetworkError.ERROR_CODE_INTERNET_OFFLINE || (error! as NSError).code == NetworkError.ERROR_CODE_NETWORK_CONNECTION_LOST {

                    failureBlock(NetworkError.ERROR_CODE_INTERNET_OFFLINE, AlertMerssage.INTERNET_OFFLINE_MESSAGE, headers)
                }
                     // Handling Request Timeout
                else if (error! as NSError).code == NetworkError.ERROR_CODE_REQUEST_TIMEOUT {
                    // TEMP: TODO:
                    let error_code = (error! as NSError).code
                    failureBlock(error_code, AlertMerssage.SERVER_ERROR_MESSAGE, headers)
                }
                
                else if (error! as NSError).code == NetworkError.STATUS_CODE_BAD_REQUEST {
                    
                    let errorDetail = ((error! as NSError).userInfo["errors"] as? [[String: Any]])?.first?["detail"] as? String ?? (error! as NSError).localizedDescription
                   
                    let error_code = (error! as NSError).code
                    failureBlock(error_code, errorDetail , headers)
                }
                    // Handling Unknown Errors
                else {

                    failureBlock(0, AlertMerssage.UNKNOWN_ERROR_MESSAGE, headers)
                }
                return
            }
            
           
           
            //Set responseStatusCode to 200 if data retrieving from a local json file for Data Seeding
            let responseStatusCode: Int = response.url?.pathExtension == "json" ? 200 : (response as! HTTPURLResponse).statusCode

            if NetworkError.STATUS_CODE_REQUEST_SUCCESS_RANGE.contains(responseStatusCode) {
                if responseStructure == self.RESPONSE_STRUCTURE.C {
                    /* JSON De-Serialization if anticipated response data structure conforms to Codable*/
                    do {
                        
                        if return_response != nil {
                            let decode_model = return_response
                            let result = try JSONDecoder().decode(decode_model!, from: data)
                            successBlock(result)
                        }else {
                            let result = try JSONDecoder().decode(type, from: data)
                            successBlock(result)
                        }
                        
                    } catch {
                     /* Error In Json response - De-serialization - Codable_Object */
                        failureBlock(0, AlertMerssage.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE, headers)
                    }
                }
                 else {
                    if let resultString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        successBlock(resultString)
                    } else {

                        /* Error In Json response - De-serialization - Other_Forms */
                        failureBlock(0, AlertMerssage.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE, headers)
                    }
                }
            } else {

                failureBlock(responseStatusCode, error?.localizedDescription ?? "", headers)
            }
        }

        task.resume()
    }

}

extension Network {
    func getNewsFeed(nextPage:Int, pageSize: Int, offset:Int,successBlock: @escaping SuccessBlock, failureBlock: @escaping FailureBlock) {
        
        guard let url = URL(string: Config.paginatedNewsURL(nextPage: nextPage, pageSize: pageSize, offset:offset)) else {return}
        let responseModel = [NewsModel].self
        let requestOptions: [String: String] = ["Content-Type": "application/json"]
        
        performWebServiceRequest(type: responseModel, with: url, requestType: NETWORK_REQUEST_TYPES.GET.rawValue, requestOptions: requestOptions, responseStructure: RESPONSE_STRUCTURE.C, successBlock: successBlock, failureBlock: failureBlock,return_response: responseModel)
        
    }
}
