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

final class TipsViewController: UITableViewController, StoryboardView {

  @IBOutlet private weak var requestCountLabel: UILabel!
  @IBOutlet private weak var objectsCountLabel: UILabel!
  
  var disposeBag = DisposeBag()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // ReactorKitの設計思想から外れますが、ViewやReactorのUnit testを行わないのであれば
    // View内で初期化してもいいかなと思う。
    reactor = TipsReactor()
  }
  
  func bind(reactor: TipsReactor) {
    // State
    reactor.state.map { String($0.requestCount) }
      .bind(to: requestCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state.map { String($0.objects.count) }
      .bind(to: objectsCountLabel.rx.text)
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
      case 1: return .requestError
      case 2: return .requestConfirmed
      case 3: return .requestObject
      default: return nil
      }
    default: return nil
    }
  }
}
