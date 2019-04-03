//
//  AnimatedImageView.swift
//  JSAnimatedView
//
//  Created by Max on 2019/4/2.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

open class AnimatedImageView: UIImageView {
    
    // MARK: TargetProxy
    /// 代理对象，用于防止CADDisplayLink与AnimatedImageView之间的循环引用
    class TargetProxy {

        // MARK: 私有属性
        private weak var target: AnimatedImageView?
        
        // MARK: 初始化方法
        init(target: AnimatedImageView) {
            self.target = target
        }
        
        // MARK: 公开方法
        @objc func onScreenUpdate() {
            self.target?.updateFrameIfNeeded()
        }
    }
    
    // MARK: 公开属性
    /// 当视图可见时是否自动播放动画，默认值为true
    public var autoPlayAnimatedImage: Bool = true
    
    /// 预先加载帧数量，默认值为10
    public var framePreloadCount: Int = 10
    
    /// 是否将GIF尺寸预先缩放至视图尺寸大小，
    /// 如果加载图像尺寸大于视图尺寸大小，则有助于减少内存占用，默认值为true
    public var needsPrescaling: Bool = true
    
    /// 动画定时器循环模式，默认值为 RunLoop.Mode.common
    /// 如果设置为 RunLoop.Mode.default，则动画在 UIScrollView 滚动期间将暂停
    public var runLoopMode: RunLoop.Mode = .common {
        willSet {
            guard self.runLoopMode == newValue else {
                return
            }
            self.stopAnimating()
            self.displayLink.remove(from: .main, forMode: self.runLoopMode)
            self.displayLink.add(to: .main, forMode: newValue)
            self.startAnimating()
        }
    }
    
    /// 播放重复计数，动画图像将保持动画，直到循环计数达到该数值，
    /// 重置该数值时将同时重置该动画
    /// 默认值为 .infinite
    public var repeatCount: RepeatCount = .infinite {
        didSet {
            if oldValue != self.repeatCount {
                self.reset()
                self.setNeedsDisplay()
                self.layer.setNeedsDisplay()
            }
        }
    }
    
    // MARK: 私有属性
    /// Animator实例对象，用于保存帧数据
    private var animator: Animator?
    
    /// 用于标记是否创建CADDisplayLink实例对象
    private var isDisplayLinkInitialized: Bool = false
    
    /// 用于预加载图像的队列
    private lazy var preloadQueue: DispatchQueue = {
        return DispatchQueue(label: "com.sibo.jian.JSAnimatedView.Animator.preloadQueue")
    }()
    
    private lazy var displayLink: CADisplayLink = {
        self.isDisplayLinkInitialized = true
        let displayLink = CADisplayLink(target: TargetProxy(target: self), selector: #selector(TargetProxy.onScreenUpdate))
        displayLink.add(to: .main, forMode: self.runLoopMode)
        displayLink.isPaused = true
        return displayLink
    }()
    
    // MARK: 初始化方法
    deinit {
        if self.isDisplayLinkInitialized {
            self.displayLink.invalidate()
        }
    }
    
    // MARK: 重写父类属性/方法
    open override var image: UIImage? {
        didSet {
            if self.image != oldValue {
                self.reset()
            }
            self.setNeedsDisplay()
            self.layer.setNeedsDisplay()
        }
    }

    open override var isAnimating: Bool {
        if self.isDisplayLinkInitialized {
            return !self.displayLink.isPaused
        }
        else {
            return super.isAnimating
        }
    }
    
    /// 开始动画
    open override func startAnimating() {
        guard !self.isAnimating else {
            return
        }
        if self.animator?.isReachMaxRepeatCount ?? false {
            return
        }
        self.displayLink.isPaused = false
    }
    
    /// 结束动画
    open override func stopAnimating() {
        super.stopAnimating()
        if self.isDisplayLinkInitialized {
            self.displayLink.isPaused = true
        }
    }
    
    open override func display(_ layer: CALayer) {
        if let currentFrame = self.animator?.currentFrameImage {
            self.layer.contents = currentFrame.cgImage
        }
        else {
            self.layer.contents = self.image?.cgImage
        }
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        self.didMove()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.didMove()
    }
    
    // MARK: 私有方法
    /// 重置Animator实例对象
    private func reset() {
        self.animator = nil
        if let imageSource = self.image?.imageSource {
            let animator = Animator(
                imageSource: imageSource,
                contentMode: self.contentMode,
                size: self.bounds.size,
                framePreloadCount: self.framePreloadCount,
                repeatCount: self.repeatCount,
                preloadQueue: self.preloadQueue)
            animator.needsPrescaling = self.needsPrescaling
            animator.prepareFramesAsynchronously()
            self.animator = animator
        }
        self.didMove()
    }
    
    private func didMove() {
        if self.autoPlayAnimatedImage && self.animator != nil {
            if let _ = self.superview, let _ = self.window {
                self.startAnimating()
            }
            else {
                self.stopAnimating()
            }
        }
    }
    
    private func updateFrameIfNeeded() {
        guard let animator = self.animator else {
            return
        }
        guard !animator.isFinished else {
            self.stopAnimating()
            return
        }
        var duration: CFTimeInterval = self.displayLink.duration
        if #available(iOS 10.0, *) {
            if self.displayLink.preferredFramesPerSecond != 0 {
                duration = 1.0 / Double(self.displayLink.preferredFramesPerSecond)
            }
        }
        animator.shouldChangeFrame(with: duration) { [weak self] (hasNewFrame) in
            if hasNewFrame {
                self?.layer.setNeedsDisplay()
            }
        }
    }
}
