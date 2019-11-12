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
