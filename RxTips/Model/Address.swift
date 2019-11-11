//
//  Address.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/11.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RealmSwift

protocol Address {
  
  var id: String { get }
  var addressNum: Int { get }
}

struct AddressModel: Address {
  
  let id: String
  let addressNum: Int
}

extension AddressModel: Codable {
  
  enum CodingKeys: String, CodingKey {
    case id
    case addressNum = "address_num"
  }
}

extension AddressModel: ObjectConvertible {
  
  typealias Result = AddressObject
}

final class AddressObject: Object, Address {
  
  @objc dynamic var id = ""
  @objc dynamic var addressNum = 0
  
  override class func primaryKey() -> String? {
    return #keyPath(id)
  }
}

extension AddressObject: ObjectConvertible, Codable {
  
  typealias Result = AddressModel
  typealias CodingKeys = Result.CodingKeys
}
