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
struct ServiceContainer {
  
  let navigator: NavigatorType
  let alertController: AlertControllerType
  let hudController: HUDControllerType
  let apiClient: APIClientType
  let store: StoreType
}

/// この初期化方法とどこでretainするかは改良の余地がある。
/// アプリの生存期間中に解放しないのであれば `private let` でいいと思う。
private let serviceContainer = ServiceContainer(
    navigator: Navigator(),
    alertController: AlertController(),
    hudController: HUDController(),
    apiClient: APIClient(),
    store: Store(
      configure: Realm.Configuration(
        deleteRealmIfMigrationNeeded: true
      )
    )
)

extension ServiceAvailable {
  
  static subscript<T>(dynamicMember keyPath: KeyPath<ServiceContainer, T>) -> T {
    serviceContainer[keyPath: keyPath]
  }
}

/// Serviceは必要な箇所からのみアクセスできるように制限する
/// - Note: Viewからはアクセス可能にはしないこと（Exampleは除く）
typealias Reactor = ReactorKit.Reactor & ServiceAvailable
extension Reactive: ServiceAvailable {}
extension Observable: ServiceAvailable {}
extension PrimitiveSequence: ServiceAvailable {}
extension AlertController: ServiceAvailable {}
extension APIRequestType: ServiceAvailable {}
