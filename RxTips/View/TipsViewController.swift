//
//  TipsViewController.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxOptional

final class TipsViewController: UITableViewController, StoryboardView {

  @IBOutlet private weak var requestCountLabel: UILabel!
  @IBOutlet private weak var objectsCountLabel: UILabel!
  
  @IBOutlet private weak var userIDLabel: UILabel!
  @IBOutlet private weak var userSnakeCaseKeyLabel: UILabel!
  
  var disposeBag = DisposeBag()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // ReactorKitの設計思想から外れますが、ViewやReactorのUnit testを行わないのであれば
    // View内で初期化してもいいかなと思う。
    reactor = TipsReactor(userID: "target")
  }
  
  func bind(reactor: TipsReactor) {
    // State
    reactor.state.map { String($0.requestCount) }
      .bind(to: requestCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state.map { String($0.objects.count) }
      .bind(to: objectsCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.user?.id }
      .replaceNilWith("nil")
      .bind(to: userIDLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state.map {
      $0.user.flatMap { String($0.snakeCaseKey) }
    }
    .replaceNilWith("nil")
    .bind(to: userSnakeCaseKeyLabel.rx.text)
    .disposed(by: disposeBag)
    
    // Action
    tableView.rx.itemSelected
      .do(onNext: { [weak self] in self?.tableView.deselectRow(at: $0, animated: true) })
      .compactMap { $0.action }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

private extension IndexPath {
  
  // サンプルプロジェクトなので簡易的にIndexPathからActionを生成
  var action: TipsReactor.Action? {
    switch section {
    case 0:
      switch row {
      case 0: return .request
      case 1: return .showNestedHUD
      case 2: return .requestError
      case 3: return .requestConfirmed
      case 4: return .requestSelection
      default: return nil
      }
    case 1:
      switch row {
      case 0: return .requestObject
      case 1: return .requestJSON
      case 2: return .upsertUser
      case 3: return .deleteUser
      case 4: return .convertResponseToModel
      default: return nil
      }
    default: return nil
    }
  }
}
