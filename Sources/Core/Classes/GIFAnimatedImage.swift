//
//  GIFAnimatedImage.swift
//  JSAnimatedView
//
//  Created by Max on 2019/3/28.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation
import ImageIO

/// 用于GIF图像的解码，该类从CGImageSource中提取帧数据，并保留帧图像数据供后期使用。
class GIFAnimatedImage {
    
    // MARK: 公开属性
    let images: [UIImage]
    
    let duration: TimeInterval
    
    // MARK: 初始化方法
    init?(from imageSource: CGImageSource, for info: [String: Any], options: ImageCreatingOptions) {
        let frameCount = CGImageSourceGetCount(imageSource)
        
        var gifImages = [UIImage]()
        var gifDuration = 0.0
        
        for index in 0..<frameCount {
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, index, info as CFDictionary) else {
                return nil
            }
            if frameCount == 1 {
                gifDuration = .infinity
            }
            else {
                // 获取当前动画帧的持续时间
                gifDuration += GIFAnimatedImage.getFrameDuration(from: imageSource, at: index)
            }
            gifImages.append(UIImage(cgImage: imageRef, scale: options.scale, orientation: .up))
            if options.onlyFirstFrame {
                break
            }
        }
        
        self.images = gifImages
        self.duration = gifDuration
    }
    
    // MAKR: 公开方法
    /// 从kCGImagePropertyGIFDictionary中获取GIF动画持续时间
    static func getFrameDuration(from gifInfo: [String: Any]?) -> TimeInterval {
        let defaultFrameDuration = 0.1
        guard let gifInfo = gifInfo else {
            return defaultFrameDuration
        }
        let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
        let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
        let duration = unclampedDelayTime ?? delayTime
        guard let frameDuration = duration else {
            return defaultFrameDuration
        }
        return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : defaultFrameDuration
    }
    
    /// 从CGImageSource中获取指定帧处持续时间
    static func getFrameDuration(from imageSource: CGImageSource, at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil) as? [String: Any] else {
            return 0.0
        }
        let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        return self.getFrameDuration(from: gifInfo)
    }
}
