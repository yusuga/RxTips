//
//  StoreServiceType.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/07.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol StoreServiceType: AnyObject {
  
  func realm() throws -> Realm
}

extension StoreServiceType {
  
  func add<O: Object>(
    _ object: O, update: RealmSwift.Realm.UpdatePolicy
  ) throws -> O {
    do {
      let realm = try self.realm()
      try realm.write {
        realm.add(object, update: update)
      }
      return object
    } catch {
      throw error
    }
  }
  
  func add<S: Sequence>(
    _ objects: S, update: RealmSwift.Realm.UpdatePolicy
  ) throws -> S where S.Iterator.Element: Object {
    do {
      let realm = try self.realm()
      try realm.write {
        realm.add(objects, update: update)
      }
      return objects
    } catch {
      throw error
    }
  }
}

extension StoreServiceType {
  
  func add<O: Object>(
    _ object: O, update: RealmSwift.Realm.UpdatePolicy
  ) -> Single<O> {
    return Single.create { observer in
      do {
        try observer(.success(self.add(object, update: update)))
      } catch {
        observer(.failure(error))
      }
      return Disposables.create()
    }
  }
  
  func add<S: Sequence>(
    _ objects: S, update: RealmSwift.Realm.UpdatePolicy
  ) -> Single<S> where S.Iterator.Element: Object {
    return Single.create { observer in
      do {
        try observer(.success(self.add(objects, update: update)))
      } catch {
        observer(.failure(error))
      }
      return Disposables.create()
    }
  }
}

extension StoreServiceType {
  
  func add<O: Object>(
    update: RealmSwift.Realm.UpdatePolicy = .modified
  ) -> ((O) throws -> Single<Object>) {
    return { source in
      return self.add(source, update: update)
    }
  }
  
  func add<S: Sequence>(
    _ update: RealmSwift.Realm.UpdatePolicy = .modified
  ) -> ((S) throws -> Single<S>) where S.Iterator.Element: Object {
    return { source in
      return self.add(source, update: update)
    }
  }
}

extension StoreServiceType {
  
  func add<O: ObjectConvertible & Encodable>(
    update: RealmSwift.Realm.UpdatePolicy = .modified
  ) -> ((O) throws -> Single<O.Result>) where O.Result: Object {
    
    return { source in
      return Single.just(source)
        .map { try $0.convert() }
        .flatMap { self.add($0, update: .modified) }
    }
  }
  
  func add<S: Sequence>(
    update: RealmSwift.Realm.UpdatePolicy = .modified
  ) -> ((S) throws -> Single<[S.Iterator.Element.Result]>) where S.Iterator.Element: ObjectConvertible, S.Iterator.Element: Encodable, S.Iterator.Element.Result: Object {
    return { source in
      return Single.just(source)
        .map { try $0.map { try $0.convert() } }
        .flatMap { self.add($0, update: .modified) }
    }
  }
}

extension StoreServiceType {
  
  func delete(_ object: Object) throws {
    do {
      let realm = try self.realm()
      try realm.write {
        realm.delete(object)
      }
    } catch {
      throw error
    }
  }
  
  func delete(_ object: Object) -> Single<Void> {
    return Single.create { observer in
      do {
        try observer(.success(self.delete(object)))
      } catch {
        observer(.failure(error))
      }
      return Disposables.create()
    }
  }
  
  func delete() -> ((Object) throws -> Single<Void>) {
    return { source in
      return Single.just(source)
        .flatMap { self.delete($0) }
    }
  }
}

extension StoreServiceType {
  
  func fetch<O: Object>(_ type: O.Type, forPrimaryKey primaryKey: String) -> Single<O?> {
    return Single.create { observer in
      do {
        try observer(
          .success(
            self.realm().object(
              ofType: type, forPrimaryKey: primaryKey
            )
          )
        )
      } catch {
        observer(.failure(error))
      }
      return Disposables.create()
    }
  }
  
  func fetch<O: Object>(_ type: O.Type) -> Observable<[O]> {
    do {
      return try Observable.array(
        from: self.realm().objects(type)
      )
    } catch {
      return Observable.error(error)
    }
  }
}
