//
//  UIImage+JSAnimatedView.swift
//  JSAnimatedView
//
//  Created by Max on 2019/4/2.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation
import MobileCoreServices

private var imageSourceKey: Void?
private var animatedImageDataKey: Void?

extension UIImage {
    
    // MARK: 公开属性
    private(set) var imageSource: CGImageSource? {
        set {
            setRetainedAssociatedObject(self, &imageSourceKey, newValue)
        }
        get {
            return getAssociatedObject(self, &imageSourceKey)
        }
    }
    
    private(set) var animatedImageData: Data? {
        set {
            setRetainedAssociatedObject(self, &animatedImageDataKey, newValue)
        }
        get {
            return getAssociatedObject(self, &animatedImageDataKey)
        }
    }

    // MARK: 公开方法
    static func animatedImage(data: Data, options: ImageCreatingOptions) -> UIImage? {
        let info: [String: Any] = [
            kCGImageSourceShouldCache as String: true,
            kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
        ]
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, info as CFDictionary) else {
            return nil
        }
        
        var image: UIImage?
        if options.preloadAll || options.onlyFirstFrame {
            guard let animatedImage = GIFAnimatedImage(from: imageSource, for: info, options: options) else {
                return nil
            }
            if options.onlyFirstFrame {
                image = animatedImage.images.first
            }
            else {
                let duration = options.duration <= 0.0 ? animatedImage.duration : options.duration
                image = self.animatedImage(with: animatedImage.images, duration: duration)
            }
            image?.animatedImageData = data
        }
        else {
            image = UIImage(data: data, scale: options.scale)
            image?.imageSource = imageSource
            image?.animatedImageData = data
        }
        
        return image
    }
    
    static func image(data: Data, options: ImageCreatingOptions) -> UIImage? {
        var image: UIImage?
        switch data.imageFormat {
        case .JPEG, .PNG, .unknown:
            image = UIImage(data: data, scale: options.scale)
        case .GIF:
            image = UIImage.animatedImage(data: data, options: options)
        }
        return image
    }
}
