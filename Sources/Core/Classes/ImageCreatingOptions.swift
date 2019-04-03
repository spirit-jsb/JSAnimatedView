//
//  ImageCreatingOptions.swift
//  JSAnimatedView
//
//  Created by Max on 2019/4/3.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

/// 图像创建选项
public struct ImageCreatingOptions {
    
    // MARK: 公开属性
    /// 需要创建图像的目标比例
    let scale: CGFloat
    
    /// 如果创建动画图像，预期的动画持续时间
    let duration: TimeInterval
    
    /// 如果创建动画图像，是否预先加载所有帧信息
    let preloadAll: Bool
    
    /// 如果创建动画图像，是否预览第一帧图像
    let onlyFirstFrame: Bool

    // MARK: 初始化方法
    /// 初始化并创建一个ImageCreatingOptions实例对象
    ///
    /// - Parameters:
    ///   - scale: 需要创建图像的目标比例，默认值为1.0
    ///   - duration: 如果创建动画图像，预期的动画持续时间
    ///               小于或等于0.0时表示，动画持续时间由帧数据决定，默认值为0.0
    ///   - preloadAll: 如果创建动画图像，是否预先加载所有帧信息，默认值为false
    ///   - onlyFirstFrame: 如果创建动画图像，是否预览第一帧图像，默认值为false
    init(
        scale: CGFloat = 1.0,
        duration: TimeInterval = 0.0,
        preloadAll: Bool = false,
        onlyFirstFrame: Bool = false)
    {
        self.scale = scale
        self.duration = duration
        self.preloadAll = preloadAll
        self.onlyFirstFrame = onlyFirstFrame
    }
}
