//
//  Array+JSAnimatedView.swift
//  JSAnimatedView
//
//  Created by Max on 2019/3/22.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension Array {
    
    // MARK: 公开方法
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
