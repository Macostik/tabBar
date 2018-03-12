//  
//  TabBarViewModel.swift
//  DynamicHeightStreamView
//
//  Created by Yura Granchenko on 3/12/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import StreamView

class TabBarViewModel {

    var items = BehaviorRelay(value: [""])
    var selectItem = PublishSubject<StreamItem?>()
}

extension TabBarViewModel {

}
