//
//  JSON.swift
//  RxTipsTests
//
//  Created by Yu Sugawara on 2019/11/12.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
@testable import RxTips

enum Helper {
  
  static let encoder = JSONEncoder.default
  static let decoder = JSONDecoder.default
  
  static func equalJSON(_ json1: Data, to json2: Data) -> Bool {
    #if true
    print("json1: \(String(data: removeNullAndSortedFromJSON(json1), encoding: .utf8)!)")
    print("json2: \(String(data: removeNullAndSortedFromJSON(json2), encoding: .utf8)!)")
    #endif
    return removeNullAndSortedFromJSON(json1) == removeNullAndSortedFromJSON(json2)
  }

  static func removeNullAndSortedFromJSON(_ data: Data) -> Data {
    // - Dictionaryからnullを削除
    // - サポートしていないケースは以下
    //   - nullを直接含むArray
    func removedNull(from dict: [String: Any?]) -> [String: Any] {
      return dict.compactMapValues { value in
        switch value {
        case let dict as [String: Any?]:
          return removedNull(from: dict)
        case let array as [[String: Any?]]:
          return array.map { removedNull(from: $0) }
        default:
          return value
        }
      }
    }
    
    return try! JSONSerialization.data(
      withJSONObject: removedNull(
        from: JSONSerialization.jsonObject(with: data, options: []) as! [String: Any?]
      ),
      options: [.sortedKeys]
    )
  }
  
  private static let dataStr = Data("def".utf8).base64EncodedString()
  private static let dateStr = "2019-11-11T11:11:11Z"
  
  static var jsonWithFill: Data {
    func jsonWithEmptyArray(primaryID1: String, primaryID2: String) -> Data {
      return """
        {
        \(primitiveValuesJSON(primaryID: primaryID1)),
        "object": {
        \(primitiveValuesJSON(primaryID: primaryID2))
        },
        "objects": []
        }
        """.data(using: .utf8)!
    }
    
    return """
      {
      \(primitiveValuesJSON(primaryID: "1")),
      "object": {
      \(primitiveValuesJSON(primaryID: "2"))
      },
      "objects": [
      {\(primitiveValuesJSON(primaryID: "3"))},
      {\(primitiveValuesJSON(primaryID: "4"))}
      ]
      }
      """.data(using: .utf8)!
  }
  
  static func jsonWithNull(isNullKeyRemoved: Bool) -> Data {
    let json = """
      {
      \(primitiveValuesJSONWithNull(primaryID: "10")),
      "object": null,
      "objects": []
      }
      """.data(using: .utf8)!
    
    if !isNullKeyRemoved {
      return json
    }
    
    // トップの階層のnullを削除
    return try! JSONSerialization.data(
      withJSONObject: (JSONSerialization.jsonObject(
        with: json, options: []
        ) as! [String: Any?])
        .compactMapValues { $0 },
      options: []
    )
  }
  
  static var complexJSON: Data {
    return """
      {
      \(primitiveValuesJSON(primaryID: "100")),
      "object": {
      \(primitiveValuesJSONWithNull(primaryID: "101"))
      },
      "objects": [
      \(String(data: jsonWithFill, encoding: .utf8)!),
      \(String(data: jsonWithNull(isNullKeyRemoved: false), encoding: .utf8)!)
      ]
      }
      """.data(using: .utf8)!
  }
  
  static var complexJSONAnswer: Data {
    return """
      {
      \(primitiveValuesJSON(primaryID: "100")),
      "object": {
      \(primitiveValuesJSONWithNull(primaryID: "101"))
      },
      "objects": [
      \(String(data: jsonWithFill, encoding: .utf8)!),
      \(String(data: jsonWithNull(isNullKeyRemoved: true), encoding: .utf8)!)
      ]
      }
      """.data(using: .utf8)!
  }
    
  static func primitiveValuesJSON(primaryID: String) -> String {
    return """
    "string": "\(primaryID)",
    "data": "\(dataStr)",
    "date": "\(dateStr)",
    "bool": true,
    "int": 123,
    "int8": 123,
    "int16": 123,
    "int32": 123,
    "int64": 123,
    "float": 2.5,
    "double": 2.5,

    "stringOpt": "abc",
    "dataOpt": "\(dataStr)",
    "dateOpt": "\(dateStr)",
    "boolOpt": true,
    "intOpt": 123,
    "int8Opt": 123,
    "int16Opt": 123,
    "int32Opt": 123,
    "int64Opt": 123,
    "floatOpt": 2.5,
    "doubleOpt": 2.5,

    "stringList": ["abc"],
    "dataList": ["\(dataStr)"],
    "dateList": ["\(dateStr)"],
    "boolList": [true],
    "intList": [123],
    "int8List": [123],
    "int16List": [123],
    "int32List": [123],
    "int64List": [123],
    "floatList": [2.5],
    "doubleList": [2.5],

    "stringOptList": ["abc"],
    "dataOptList": ["\(dataStr)"],
    "dateOptList": ["\(dateStr)"],
    "boolOptList": [true],
    "intOptList": [123],
    "int8OptList": [123],
    "int16OptList": [123],
    "int32OptList": [123],
    "int64OptList": [123],
    "floatOptList": [2.5],
    "doubleOptList": [2.5]
    """
  }
  
  static func primitiveValuesJSONWithNull(primaryID: String) -> String {
    return """
    "string": "\(primaryID)",
    "data": "\(dataStr)",
    "date": "\(dateStr)",
    "bool": true,
    "int": 123,
    "int8": 123,
    "int16": 123,
    "int32": 123,
    "int64": 123,
    "float": 2.5,
    "double": 2.5,
    
    "stringOpt": null,
    "dataOpt": null,
    "dateOpt": null,
    "boolOpt": null,
    "intOpt": null,
    "int8Opt": null,
    "int16Opt": null,
    "int32Opt": null,
    "int64Opt": null,
    "floatOpt": null,
    "doubleOpt": null,
    
    "stringList": ["abc"],
    "dataList": ["\(dataStr)"],
    "dateList": ["\(dateStr)"],
    "boolList": [true],
    "intList": [123],
    "int8List": [123],
    "int16List": [123],
    "int32List": [123],
    "int64List": [123],
    "floatList": [2.5],
    "doubleList": [2.5],
    
    "stringOptList": [null],
    "dataOptList": [null],
    "dateOptList": [null],
    "boolOptList": [null],
    "intOptList": [null],
    "int8OptList": [null],
    "int16OptList": [null],
    "int32OptList": [null],
    "int64OptList": [null],
    "floatOptList": [null],
    "doubleOptList": [null]
    """
  }
}
