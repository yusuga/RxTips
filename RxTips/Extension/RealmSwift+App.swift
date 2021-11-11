//
//  RealmSwift+App.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/13.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RealmSwift

extension List {

    func append<S>(objectsIn objects: S?) where Element == S.Element, S : Sequence {
        guard let objects = objects else {
            return
        }
        append(objectsIn: objects)
    }
}
