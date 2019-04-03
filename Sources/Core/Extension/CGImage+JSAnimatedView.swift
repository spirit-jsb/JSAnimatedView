//
//  CGImage+JSAnimatedView.swift
//  JSAnimatedView
//
//  Created by Max on 2019/3/28.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension CGImage {

    // MARK: 私有属性
    private var size: CGSize {
        return CGSize(width: CGFloat(self.width), height: CGFloat(self.height))
    }

    // MARK: 公开方法
    func resize(to size: CGSize, for contentMode: UIView.ContentMode) -> CGImage {
        switch contentMode {
        case .scaleAspectFit:
            return self.resize(to: size, for: .aspectFit)
        case .scaleAspectFill:
            return self.resize(to: size, for: .aspectFill)
        default:
            return self.resize(to: size)
        }
    }
    
    // MAKR: 私有方法
    private func resize(to size: CGSize) -> CGImage {
        let alphaInfo = self.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        var hasAlpha = false
        if alphaInfo == CGImageAlphaInfo.premultipliedLast.rawValue ||
            alphaInfo == CGImageAlphaInfo.premultipliedFirst.rawValue ||
            alphaInfo == CGImageAlphaInfo.first.rawValue ||
            alphaInfo == CGImageAlphaInfo.last.rawValue {
            hasAlpha = true
        }
        var bitmapInfo = CGImageByteOrderInfo.order32Little.rawValue
        bitmapInfo |= hasAlpha ? CGImageAlphaInfo.premultipliedFirst.rawValue : CGImageAlphaInfo.noneSkipFirst.rawValue
        guard let context = CGContext(data: nil,
                                      width: Int(size.width),
                                      height: Int(size.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: bitmapInfo) else
        {
            return self
        }
        let rect = CGRect(origin: .zero, size: size)
        context.interpolationQuality = .high
        context.draw(self, in: rect)
        return context.makeImage() ?? self
    }
    
    private func resize(to targetSize: CGSize, for contentMode: ContentMode) -> CGImage {
        let newSize = self.size.resize(to: targetSize, for: contentMode)
        return self.resize(to: newSize)
    }
}
