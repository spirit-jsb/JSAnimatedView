//
//  AnimatedImageView+JSAnimatedView.swift
//  JSAnimatedView
//
//  Created by Max on 2019/4/2.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

public extension AnimatedImageView {
    
    // MARK: 公开方法
    func animate(withGIFNamed imageName: String, options: ImageCreatingOptions? = nil) {
        self.prepareForAnimation(withGIFNamed: imageName, options: options)
    }
    
    func animate(withGIFData imageData: Data, options: ImageCreatingOptions? = nil) {
        self.prepareForAnimation(withGIFData: imageData, options: options)
    }
    
    // MARK: 私有方法
    private func prepareForAnimation(withGIFNamed imageName: String, options: ImageCreatingOptions?) {
        guard let name = imageName.components(separatedBy: ".")[safe: 0], let path = Bundle.main.url(forResource: name, withExtension: "gif"), let data = try? Data(contentsOf: path) else
        {
            return
        }
        self.prepareForAnimation(withGIFData: data, options: options)
    }
    
    private func prepareForAnimation(withGIFData imageData: Data, options: ImageCreatingOptions?) {
        self.image = UIImage.image(data: imageData, options: options ?? ImageCreatingOptions())
    }
}
