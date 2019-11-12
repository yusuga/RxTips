//
//  Object.swift
//  RxTipsTests
//
//  Created by Yu Sugawara on 2019/11/12.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RealmSwift
@testable import RxTips

/// - 元とした定義: https://github.com/realm/realm-cocoa/blob/57d02ed7894b2531b0bc7e0d1653422a8d6eda67/RealmSwift/Tests/CodableTests.swift#L22
final class RealmObject: Object, Codable {
  
  @objc dynamic var string = ""
  @objc dynamic var data = Data()
  @objc dynamic var date = Date()
  @objc dynamic var bool = false
  @objc dynamic var int: Int = 0
  @objc dynamic var int8: Int8 = 0
  @objc dynamic var int16: Int16 = 0
  @objc dynamic var int32: Int32 = 0
  @objc dynamic var int64: Int64 = 0
  @objc dynamic var float: Float = 0
  @objc dynamic var double: Double = 0

  @objc dynamic var stringOpt: String?
  @objc dynamic var dataOpt: Data?
  @objc dynamic var dateOpt: Date?
  var boolOpt = RealmOptional<Bool>()
  var intOpt = RealmOptional<Int>()
  var int8Opt = RealmOptional<Int8>()
  var int16Opt = RealmOptional<Int16>()
  var int32Opt = RealmOptional<Int32>()
  var int64Opt = RealmOptional<Int64>()
  var floatOpt = RealmOptional<Float>()
  var doubleOpt = RealmOptional<Double>()

  var stringList = List<String>()
  var dataList = List<Data>()
  var dateList = List<Date>()
  var boolList = List<Bool>()
  var intList = List<Int>()
  var int8List = List<Int8>()
  var int16List = List<Int16>()
  var int32List = List<Int32>()
  var int64List = List<Int64>()
  var floatList = List<Float>()
  var doubleList = List<Double>()

  var stringOptList = List<String?>()
  var dataOptList = List<Data?>()
  var dateOptList = List<Date?>()
  var boolOptList = List<Bool?>()
  var intOptList = List<Int?>()
  var int8OptList = List<Int8?>()
  var int16OptList = List<Int16?>()
  var int32OptList = List<Int32?>()
  var int64OptList = List<Int64?>()
  var floatOptList = List<Float?>()
  var doubleOptList = List<Double?>()

  @objc dynamic var object: SubRealmObject?
  var objects = List<SubRealmObject>()
  
  override class func primaryKey() -> String? {
    return #keyPath(string)
  }
}

extension RealmObject: ObjectConvertible {
  
  typealias Result = SwiftObject
}

final class SubRealmObject: Object, Codable {
  
  @objc dynamic var string = ""
  @objc dynamic var data = Data()
  @objc dynamic var date = Date()
  @objc dynamic var bool = false
  @objc dynamic var int: Int = 0
  @objc dynamic var int8: Int8 = 0
  @objc dynamic var int16: Int16 = 0
  @objc dynamic var int32: Int32 = 0
  @objc dynamic var int64: Int64 = 0
  @objc dynamic var float: Float = 0
  @objc dynamic var double: Double = 0
  
  @objc dynamic var stringOpt: String?
  @objc dynamic var dataOpt: Data?
  @objc dynamic var dateOpt: Date?
  var boolOpt = RealmOptional<Bool>()
  var intOpt = RealmOptional<Int>()
  var int8Opt = RealmOptional<Int8>()
  var int16Opt = RealmOptional<Int16>()
  var int32Opt = RealmOptional<Int32>()
  var int64Opt = RealmOptional<Int64>()
  var floatOpt = RealmOptional<Float>()
  var doubleOpt = RealmOptional<Double>()
  
  var stringList = List<String>()
  var dataList = List<Data>()
  var dateList = List<Date>()
  var boolList = List<Bool>()
  var intList = List<Int>()
  var int8List = List<Int8>()
  var int16List = List<Int16>()
  var int32List = List<Int32>()
  var int64List = List<Int64>()
  var floatList = List<Float>()
  var doubleList = List<Double>()
  
  var stringOptList = List<String?>()
  var dataOptList = List<Data?>()
  var dateOptList = List<Date?>()
  var boolOptList = List<Bool?>()
  var intOptList = List<Int?>()
  var int8OptList = List<Int8?>()
  var int16OptList = List<Int16?>()
  var int32OptList = List<Int32?>()
  var int64OptList = List<Int64?>()
  var floatOptList = List<Float?>()
  var doubleOptList = List<Double?>()
  
  override class func primaryKey() -> String? {
    return #keyPath(string)
  }
}

extension SubRealmObject: ObjectConvertible {
  
  typealias Result = SubSwiftObject
}
