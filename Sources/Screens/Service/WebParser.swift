//
//  WebParser.swift
//  MaintainMyCity
//
//  Created by swstation on 8/29/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import Alamofire

enum ParserError: Error {
    case noResponseData
}

protocol WebParserType: class {

    static func parse<T: Codable>(data: Data, type: T.Type) throws -> T
    static func parse<T: Codable>(_ type: T.Type, from response: DataResponse<Data>) throws -> T
}

public class WebParser: WebParserType {
  
    static func parse<T>(data: Data, type: T.Type) throws -> T where T: Codable {
        let decoder =  JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: data)
    }
    
    static func parse<T>(_ type: T.Type, from response: DataResponse<Data>) throws -> T where T: Codable {
        switch response.result {
        
        case .failure(let error):
                throw error
            
        case .success(let data):
                return try parse(data: data, type: type)
            
        }
    }
  
}
