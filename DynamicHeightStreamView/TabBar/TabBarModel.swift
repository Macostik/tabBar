//  
//  TabBarModel.swift
//  DynamicHeightStreamView
//
//  Created by Yura Granchenko on 3/12/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import Foundation

enum SelectableItem {
    case first, second, third
}

struct TabBarModel {
    var selectItem = SelectableItem.first
}
