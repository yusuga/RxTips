//
//  ServiceContainer.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import ReactorKit
import URLNavigator
import RealmSwift

/// Service Locatorパターンを採用
/// 必要であればDIにした方がいいのですが、以下の理由によりService Locatorパターンを採用。
/// このアプリが他のアプリから利用されない限り、動的DIを積極的に使う理由もないのかなと個人的に思います。もしDI使うなら静的DIの方が好き。
///
/// ```
/// アプリケーションクラスを構築するにあたっては、両者ともだいたい同じようなものだが、私は Service Locator のほうが少し優勢だと思う。こちらのほうが振る舞いが素直だからだ。しかしながら、構築したクラスが複数のアプリケーションで利用されるのであれば、Dependency Injection のほうがより良い選択肢となる。
/// ```
/// 引用元: https://kakutani.com/trans/fowler/injection.html
private struct ServiceContainer: ServiceContainerType {
  
  let navigator: NavigatorType
  let alertService: AlertServiceType
  let hudService: HUDServiceType
  let apiService: APIServiceType
  let storeService: StoreServiceType
}

/// この初期化方法とどこでretainするかは改良の余地がある
/// アプリの生存期間中に解放したい場合以外はこれくらいでいいかなと思う
private let serviceContainer: ServiceContainer = {
  let navigator = Navigator()
  let config = Realm.Configuration(
    deleteRealmIfMigrationNeeded: true
  )
  
  return ServiceContainer(
    navigator: navigator,
    alertService: AlertService(dependency: .init(navigator: navigator)),
    hudService: HUDService(),
    apiService: APIService(),
    storeService: StoreService(configure: config)
  )
}()

extension Reactor {
  
  static var navigator: NavigatorType {
    return serviceContainer.navigator
    
  }
  
  var navigator: NavigatorType {
    return type(of: self).navigator
  }
  
  static var alertService: AlertServiceType {
    return serviceContainer.alertService
  }
  
  var alertService: AlertServiceType {
    return type(of: self).alertService
  }
  
  static var hudService: HUDServiceType {
    return serviceContainer.hudService
  }
  
  var hudService: HUDServiceType {
    return type(of: self).hudService
  }
  
  static var apiService: APIServiceType {
    return serviceContainer.apiService
  }
  
  var apiService: APIServiceType {
    return type(of: self).apiService
  }
  
  static var storeService: StoreServiceType {
    return serviceContainer.storeService
  }
  
  var storeService: StoreServiceType {
    return type(of: self).storeService
  }
}
