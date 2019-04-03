//
//  CGSize+JSAnimatedView.swift
//  JSAnimatedView
//
//  Created by Max on 2019/3/21.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension CGSize {

    // MARK: 私有属性
    private var aspectRatio: CGFloat {
        return self.height == 0.0 ? 1.0 : self.width / self.height
    }
    
    // MARK: 公开方法
    func resize(to size: CGSize, for contentMode: ContentMode) -> CGSize {
        switch contentMode {
        case .aspectFit:
            return self.constrained(size)
        case .aspectFill:
            return self.filling(size)
        default:
            return size
        }
    }
    
    // MAKR: 私有方法
    private func constrained(_ size: CGSize) -> CGSize {
        let aspectWidth = round(self.aspectRatio * size.height)
        let aspectHeight = round(size.width / self.aspectRatio)
        
        return aspectWidth > size.width ? CGSize(width: size.width, height: aspectHeight) : CGSize(width: aspectWidth, height: size.height)
    }

    private func filling(_ size: CGSize) -> CGSize {
        let aspectWidth = round(self.aspectRatio * size.height)
        let aspectHeight = round(size.width / self.aspectRatio)
        
        return aspectWidth < size.width ? CGSize(width: size.width, height: aspectHeight) : CGSize(width: aspectWidth, height: size.height)
    }
}
