//
//  RealmOptObject.swift
//  RxTipsTests
//
//  Created by Yu Sugawara on 2019/11/12.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
@testable import RxTips
import RealmSwift

final class RealmOptObject: Object {
  
  @objc dynamic var string = ""
  
  var boolOpt = RealmOptional<Bool>()
  var intOpt = RealmOptional<Int>()
  var int8Opt = RealmOptional<Int8>()
  var int16Opt = RealmOptional<Int16>()
  var int32Opt = RealmOptional<Int32>()
  var int64Opt = RealmOptional<Int64>()
  var floatOpt = RealmOptional<Float>()
  var doubleOpt = RealmOptional<Double>()
  
  // RealmではListのOptionalはサポートしていない
  var stringListOpt = List<String>()
  var dataListOpt = List<Data>()
  var dateListOpt = List<Date>()
  var boolListOpt = List<Bool>()
  var intListOpt = List<Int>()
  var int8ListOpt = List<Int8>()
  var int16ListOpt = List<Int16>()
  var int32ListOpt = List<Int32>()
  var int64ListOpt = List<Int64>()
  var floatListOpt = List<Float>()
  var doubleListOpt = List<Double>()
  
  override class func primaryKey() -> String? {
    return #keyPath(string)
  }
}

extension RealmOptObject: Codable {
  
  // - 以下のいずれかに該当するRealmSwift.Objectは、Decoderの `init(from:)` を実装する必要があります。
  //   - RealmOptionalのキー自体が削除されているJSONでデコードする場合
  //   - JSONでListの値がnullになる場合（オプショナルの配列）
  convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    string = try container.decode(String.self, forKey: .string)

    boolOpt.value = try container.decodeIfPresent(Bool.self, forKey: .boolOpt)
    intOpt.value = try container.decodeIfPresent(Int.self, forKey: .intOpt)
    int8Opt.value = try container.decodeIfPresent(Int8.self, forKey: .int8Opt)
    int16Opt.value = try container.decodeIfPresent(Int16.self, forKey: .int16Opt)
    int32Opt.value = try container.decodeIfPresent(Int32.self, forKey: .int32Opt)
    int64Opt.value = try container.decodeIfPresent(Int64.self, forKey: .int64Opt)
    floatOpt.value = try container.decodeIfPresent(Float.self, forKey: .floatOpt)
    doubleOpt.value = try container.decodeIfPresent(Double.self, forKey: .doubleOpt)
    
    // `List.append(objectsIn:)` はnullでもappendできるようにextensionで実装してあります。
    try stringListOpt.append(objectsIn: container.decodeIfPresent([String].self, forKey: .stringListOpt))
    try dataListOpt.append(objectsIn: container.decodeIfPresent([Data].self, forKey: .dataListOpt))
    try dateListOpt.append(objectsIn: container.decodeIfPresent([Date].self, forKey: .dateListOpt))
    try boolListOpt.append(objectsIn: container.decodeIfPresent([Bool].self, forKey: .boolListOpt))
    try intListOpt.append(objectsIn: container.decodeIfPresent([Int].self, forKey: .intListOpt))
    try int8ListOpt.append(objectsIn: container.decodeIfPresent([Int8].self, forKey: .int8ListOpt))
    try int16ListOpt.append(objectsIn: container.decodeIfPresent([Int16].self, forKey: .int16ListOpt))
    try int32ListOpt.append(objectsIn: container.decodeIfPresent([Int32].self, forKey: .int32ListOpt))
    try int64ListOpt.append(objectsIn: container.decodeIfPresent([Int64].self, forKey: .int64ListOpt))
    try floatListOpt.append(objectsIn: container.decodeIfPresent([Float].self, forKey: .floatListOpt))
    try doubleListOpt.append(objectsIn: container.decodeIfPresent([Double].self, forKey: .doubleListOpt))
  }
}

extension RealmOptObject: ObjectConvertible {
  
  typealias Result = SwiftOptObject  
}
