//
//  AnimatedFrame.swift
//  JSAnimatedView
//
//  Created by Max on 2019/3/27.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

/// 表示GIF中单个帧
struct AnimatedFrame {
    
    // MARK: 公开属性
    /// 此帧显示的图像，当从缓冲区删除此帧时，值为nil
    let image: UIImage?
    
    /// 此帧动画持续时间
    let duration: TimeInterval
    
    /// 未分配图像的AnimatedFrame实例对象
    /// 用于替换动画中不在需要的帧
    var placeholderFrame: AnimatedFrame {
        return AnimatedFrame(image: nil, duration: self.duration)
    }
    
    /// 实例对象中是否包含图像
    var isPlaceholder: Bool {
        return self.image == nil
    }
    
    // MARK: 公开方法
    /// 从可选UIImage实例对象返回一个新的AnimatedFrame实例对象
    ///
    /// - Parameter image: 一个可选的UIImage实例对象，用于分配给新的AnimatedFrame实例对象
    /// - Returns: 一个新的AnimatedFrame实例对象
    func makeAnimatedFrame(image: UIImage?) -> AnimatedFrame {
        return AnimatedFrame(image: image, duration: self.duration)
    }
}
