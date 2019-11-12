//
//  SwiftObject.swift
//  RxTipsTests
//
//  Created by Yu Sugawara on 2019/11/12.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
@testable import RxTips

struct SwiftObject: Codable {
  
  let string: String
  let data: Data
  let date: Date
  let bool: Bool
  let int: Int
  let int8: Int8
  let int16: Int16
  let int32: Int32
  let int64: Int64
  let float: Float
  let double: Double
  
  let stringOpt: String?
  let dataOpt: Data?
  let dateOpt: Date?
  let boolOpt: Bool?
  let intOpt: Int?
  let int8Opt: Int8?
  let int16Opt: Int16?
  let int32Opt: Int32?
  let int64Opt: Int64?
  let floatOpt: Float?
  let doubleOpt: Double?
  
  let stringList: [String]
  let dataList: [Data]
  let dateList: [Date]
  let boolList: [Bool]
  let intList: [Int]
  let int8List: [Int8]
  let int16List: [Int16]
  let int32List: [Int32]
  let int64List: [Int64]
  let floatList: [Float]
  let doubleList: [Double]
  
  let stringOptList: [String?]
  let dataOptList: [Data?]
  let dateOptList: [Date?]
  let boolOptList: [Bool?]
  let intOptList: [Int?]
  let int8OptList: [Int8?]
  let int16OptList: [Int16?]
  let int32OptList: [Int32?]
  let int64OptList: [Int64?]
  let floatOptList: [Float?]
  let doubleOptList: [Double?]

  let object: SubSwiftObject?
  let objects: [SubSwiftObject]
}

extension SwiftObject: ObjectConvertible {
  
  typealias Result = RealmObject
}

final class SubSwiftObject: Codable {
  
  let string: String
  let data: Data
  let date: Date
  let bool: Bool
  let int: Int
  let int8: Int8
  let int16: Int16
  let int32: Int32
  let int64: Int64
  let float: Float
  let double: Double
  
  let stringOpt: String?
  let dataOpt: Data?
  let dateOpt: Date?
  let boolOpt: Bool?
  let intOpt: Int?
  let int8Opt: Int8?
  let int16Opt: Int16?
  let int32Opt: Int32?
  let int64Opt: Int64?
  let floatOpt: Float?
  let doubleOpt: Double?
  
  let stringList: [String]
  let dataList: [Data]
  let dateList: [Date]
  let boolList: [Bool]
  let intList: [Int]
  let int8List: [Int8]
  let int16List: [Int16]
  let int32List: [Int32]
  let int64List: [Int64]
  let floatList: [Float]
  let doubleList: [Double]
  
  let stringOptList: [String?]
  let dataOptList: [Data?]
  let dateOptList: [Date?]
  let boolOptList: [Bool?]
  let intOptList: [Int?]
  let int8OptList: [Int8?]
  let int16OptList: [Int16?]
  let int32OptList: [Int32?]
  let int64OptList: [Int64?]
  let floatOptList: [Float?]
  let doubleOptList: [Double?]
}

extension SubSwiftObject: ObjectConvertible {
  
  typealias Result = SubRealmObject
}
