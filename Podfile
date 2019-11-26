platform :ios, '9.0'
inhibit_all_warnings! # 依存ライブラリのWarningを非表示にする

target 'RxTips' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
	
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'RxOptional', '~> 4.1'
  pod 'ReactorKit', '~> 2.0'
  
  pod 'RealmSwift', '~> 3.20'
  pod 'RxRealm', '~> 1.0'
  
  pod 'PKHUD', '~> 5.3'  

  pod 'URLNavigator', '~> 2.2'
  pod 'Then', '~> 2.6'

  target 'RxTipsTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end
end
