//
//  BaseRequest.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 23/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation

// Define the parameter's dictionary
public typealias ParametersDict = [String : Any]
// Define the header's dictionary
public typealias HeadersDict = [String: String]

protocol BaseRequest: AnyObject {
    var pages: Int { get }
    var endpoint: String { get }
    var params: ParametersDict? { get }
    var header: HeadersDict? { get }
}

