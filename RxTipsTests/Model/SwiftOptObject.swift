//
//  SwiftOptObject.swift
//  RxTipsTests
//
//  Created by Yu Sugawara on 2019/11/12.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
@testable import RxTips

struct SwiftOptObject: Codable {

  let string: String
  
  // Objective-Cのプリミティブ型のオプショナル
  let boolOpt: Bool?
  let intOpt: Int?
  let int8Opt: Int8?
  let int16Opt: Int16?
  let int32Opt: Int32?
  let int64Opt: Int64?
  let floatOpt: Float?
  let doubleOpt: Double?
  
  // 配列のオプショナル
  let stringListOpt: [String]?
  let dataListOpt: [Data]?
  let dateListOpt: [Date]?
  let boolListOpt: [Bool]?
  let intListOpt: [Int]?
  let int8ListOpt: [Int8]?
  let int16ListOpt: [Int16]?
  let int32ListOpt: [Int32]?
  let int64ListOpt: [Int64]?
  let floatListOpt: [Float]?
  let doubleListOpt: [Double]?
}

extension SwiftOptObject: ObjectConvertible {
  
  typealias Result = RealmOptObject
}
