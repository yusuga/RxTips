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
        \(valuesJSON(primaryID: primaryID1)),
        "object": {
        \(valuesJSON(primaryID: primaryID2))
        },
        "objects": []
        }
        """.data(using: .utf8)!
    }
    
    return """
      {
      \(valuesJSON(primaryID: "1")),
      "object": {
      \(valuesJSON(primaryID: "2"))
      },
      "objects": [
      {\(valuesJSON(primaryID: "3"))},
      {\(valuesJSON(primaryID: "4"))}
      ]
      }
      """.data(using: .utf8)!
  }
  
  static var jsonWithNull: Data {
    return """
      {
      \(valuesJSONWithNull(primaryID: "1")),
      "object": null,
      "objects": []
      }
      """.data(using: .utf8)!    
  }
  
  static var complexJSON: Data {
    return """
      {
      \(valuesJSON(primaryID: "1")),
      "object": {
      \(valuesJSONWithNull(primaryID: "2"))
      },
      "objects": [
      {\(valuesJSON(primaryID: "3"))},
      {\(valuesJSONWithNull(primaryID: "4"))}
      ]
      }
      """.data(using: .utf8)!
  }
      
  static func valuesJSON(primaryID: String) -> String {
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
  
  static func valuesJSONWithNull(primaryID: String) -> String {
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
  
  static var optJSONWithFill: Data {
    return """
    {
      "string": "1",
      "boolOpt": true,
      "intOpt": 123,
      "int8Opt": 123,
      "int16Opt": 123,
      "int32Opt": 123,
      "int64Opt": 123,
      "floatOpt": 2.5,
      "doubleOpt": 2.5,
      "stringListOpt": ["abc"],
      "dataListOpt": ["\(dataStr)"],
      "dateListOpt": ["\(dateStr)"],
      "boolListOpt": [true],
      "intListOpt": [123],
      "int8ListOpt": [123],
      "int16ListOpt": [123],
      "int32ListOpt": [123],
      "int64ListOpt": [123],
      "floatListOpt": [2.5],
      "doubleListOpt": [2.5]
    }
    """.data(using: .utf8)!
  }
  
  static var optJSONWithNull: Data {
    return """
    {
      "string": "1",
      "boolOpt": null,
      "intOpt": null,
      "int8Opt": null,
      "int16Opt": null,
      "int32Opt": null,
      "int64Opt": null,
      "floatOpt": null,
      "doubleOpt": null,
      "stringListOpt": null,
      "dataListOpt": null,
      "dateListOpt": null,
      "boolListOpt": null,
      "intListOpt": null,
      "int8ListOpt": null,
      "int16ListOpt": null,
      "int32ListOpt": null,
      "int64ListOpt": null,
      "floatListOpt": null,
      "doubleListOpt": null
    }
    """.data(using: .utf8)!
  }
  
  // RealmSwift.Objectの場合、ListがオプショナルにできないためListは必ず `[]` になります。
  static var optJSONRealmObjectAnswerWithNull: Data {
    return """
    {
      "string": "1",
      "boolOpt": null,
      "intOpt": null,
      "int8Opt": null,
      "int16Opt": null,
      "int32Opt": null,
      "int64Opt": null,
      "floatOpt": null,
      "doubleOpt": null,
      "stringListOpt": [],
      "dataListOpt": [],
      "dateListOpt": [],
      "boolListOpt": [],
      "intListOpt": [],
      "int8ListOpt": [],
      "int16ListOpt": [],
      "int32ListOpt": [],
      "int64ListOpt": [],
      "floatListOpt": [],
      "doubleListOpt": []
    }
    """.data(using: .utf8)!
  }  
  
  static var optJSONWithDeletedOptionalKeys: Data {
    return """
    {
      "string": "1"
    }
    """.data(using: .utf8)!
  }
}
