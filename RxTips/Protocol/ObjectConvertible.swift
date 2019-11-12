//
//  ObjectConvertible.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/07.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol ObjectConvertible {
  
  associatedtype Result: Decodable
}

extension ObjectConvertible where Self: Encodable {
  
  func convert() throws -> Result {
    return try decoder.decode(
      Result.self,
      from: encoder.encode(self)
    )
  }
  
  func json() throws -> Data {
    return try encoder.encode(self)
  }
  
  var encoder: JSONEncoder {
    return JSONEncoder.default
  }
  
  var decoder: JSONDecoder {
    return JSONDecoder.default
  }
}

//extension ObjectConvertible where Self: Encodable, Result: Object {
//
//  func convert() throws -> Result {
//    // RealmSwift.ObjectをJSONDecoderでdecodeするとListやRealmOptionalのvalueがnullの場合にdecodeできないため、
//    // JSONSerializationのDictionaryで初期化しています。
//    //
//    // `Object.init(value:,schema:)` を使用している理由は、メタタイプからは `required init` のみ呼び出し可能なためです。
//    // https://github.com/realm/realm-cocoa/issues/5714
//    return try Result(
//      value: JSONSerialization.jsonObject(
//        with: encoder.encode(self),
//        options: []
//      ),
//      schema: .partialPrivateShared()
//    )
//  }
//}
