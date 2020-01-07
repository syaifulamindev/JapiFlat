//
//  main.swift
//  Tes
//
//  Created by Saminos on 13/08/19.
//  Copyright © 2019 Style Theory Technologies. All rights reserved.
//

import JapiFlat
import Foundation

let dictionary: [String: Any] = sampleData
//let dictionary = convertToDictionary(data: data) ?? [:]

let json = JapiFlat.flatJson(from: dictionary) as Any
let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
let pretyJson = String(data: data, encoding: .utf8)!
print(pretyJson)

//print(json)
