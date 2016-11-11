//
//  WebServicesExtension.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/8/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

extension WebServices {
    
    // Create generic function to get single model back
    //this is after we have the ability to read the JSON--we can CALL
    func getObject<T: NetworkModel>(_ model: T, completion: @escaping (_ object: T?, _ error: String?) -> Void) {
        request(AuthRouter.restRequest(model)).responseJSON { (response) in
            WebServices.parseResponseObject(response: response, completion: completion)
        }
    }
    
    // Create generic functions for creating an object as well as getting back an array of objects
    func postObject<T: NetworkModel>(_ model: T, completion: @escaping (_ object: T?, _ error: String?) -> Void) {
        request(AuthRouter.restRequest(model)).responseJSON { (response) in
            WebServices.parseResponseObject(response: response, completion: completion)
            print(response)
        }
    }
    
    func getObjects<T: NetworkModel>(_ model: T, completion: @escaping (_ objects: [T]?, _ error: String?) -> Void) {
        request(AuthRouter.restRequest(model)).responseJSON { (response) in
            WebServices.parseResponseObjects(response: response, completion: completion)
        }
    }
    
    
    // MARK: - Response parsing functions
    // Step 5: Create generic function to process singular object
    //if successful give back ONE T (instead of an array)
    class func parseResponseObject<T: NetworkModel>(response: DataResponse<Any>, completion: (_ object: T?, _ error: String?) -> Void) {
        var object: T?
        
        guard case .success(_) = response.result, let data = response.data else {
            if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode < 300 {
                completion(T(), nil)
            } else {
                completion(nil, parseError(response: response))
            }
            return
        }
        
        do {
            //if can read the JSON
            let json = try JSON(data: data)
            object = try T(json: json)
            //give it back
            completion(object, nil)
        } catch {
            //if the JSON could not be read-then ERROR
            completion(nil, Constants.JSON.processingError)
        }
    }
    //all this function does is return a string--returns an error message
    class func parseError(response: DataResponse<Any>) -> String? {
        guard case let .failure(error) = response.result else {
            return Constants.JSON.unknownError
        }
        
        var errorString: String?
        
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                errorString = "Invalid URL: \(url) - \(error.localizedDescription)"
            case .parameterEncodingFailed(let reason):
                errorString = "Parameter encoding failed: \(error.localizedDescription) Failure Reason: \(reason)"
            case .multipartEncodingFailed(let reason):
                errorString = "Multipart encoding failed: \(error.localizedDescription) Failure Reason: \(reason)"
            case .responseValidationFailed(let reason):
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    errorString = "Downloaded file could not be read"
                case .missingContentType(let acceptableContentTypes):
                    errorString = "Content Type Missing: \(acceptableContentTypes)"
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    errorString = "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                case .unacceptableStatusCode(let code):
                    errorString = "Response status code was unacceptable: \(code)"
                }
            case .responseSerializationFailed(let reason):
                errorString = "Response serialization failed: \(error.localizedDescription) Failure Reason: \(reason)"
            }
        } else if let error = error as? URLError {
            errorString = "URLError occurred: \(error)"
        } else {
            errorString = "Unknown error: \(error)"
        }
        
        return errorString
    }
    
    
    //  Create generic function to process array of objects
    //given a dataResponse when I am done here we go  if pass a friend and the friend has a URL - return an array of freinds
    // if pass users--will return an array of users--likewise if expenses are passed then an array of expenses are returned
    //T is any object that may be a network model
    //given dataResponse - give an array OR an error
    class func parseResponseObjects<T: NetworkModel>(response: DataResponse<Any>, completion: (_ objects: [T]?, _ error: String?) -> Void) {
        var errorString: String?
        var objects: [T]?
        //if we are not successful with passing nil - then return nil and the error
        guard case .success(_) = response.result, let data = response.data else {
            completion(nil, parseError(response: response))
            return
        }
        //try to read the JSON
        do {
            //grabs data
            let json = try JSON(data: data)
            //turns it into an array
            let people = try json.getArray().map(T.init)
            objects = people
        } catch {
            //if we could not read the JSON--throw error
            errorString = Constants.JSON.processingError
        }
        //take whatever we have and hand it back
        completion(objects, errorString)
    }
    func authUser<T: NetworkModel>(_ user: T, completion:@escaping (_ user: T?, _ error: String?) -> ()) {
        print("the user...")
        print(user)
        // going to introduce a let temp
        let temp = request(WebServices.shared.baseURL + user.path(), method: user.method(), parameters: user.toDictionary(), encoding: URLEncoding.default)
        print(temp)
        temp.responseJSON { (response) in
            WebServices.parseResponseObject(response: response, completion: completion)
            
        }
    }
    
    func registerUser<T: NetworkModel>(_ user: T, completion:@escaping (_ user: T?, _ error: String?) -> ()) {
        request(WebServices.shared.baseURL + user.path(), method: user.method(), parameters: user.toDictionary(), encoding: URLEncoding.default)
            .responseJSON { (response) in
                WebServices.parseResponseObject(response: response, completion: completion)
        }
    }
}
