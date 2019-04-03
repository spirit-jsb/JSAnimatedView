//
//  Animator.swift
//  JSAnimatedView
//
//  Created by Max on 2019/4/2.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

class Animator {
    
    // MARK: 公开属性
    var isFinished: Bool = false
    
    var needsPrescaling: Bool = true
    
    /// 一个动画循环的总持续时间
    var loopDuration: TimeInterval = 0.0
    
    var contentMode = UIView.ContentMode.scaleToFill
    
    /// 当前帧的图像
    var currentFrameImage: UIImage? {
        return self.frame(at: self.currentFrameIndex)
    }
    
    /// 当前帧的动画持续时间
    var currentFrameDuration: TimeInterval {
        return self.duration(at: self.currentFrameIndex)
    }
    
    /// 当前帧的索引
    var currentFrameIndex = 0 {
        didSet {
            self.previousFrameIndex = oldValue
        }
    }
    
    var previousFrameIndex = 0 {
        didSet {
            self.preloadQueue.async {
                self.updatePreloadedFrames()
            }
        }
    }
    
    var isReachMaxRepeatCount: Bool {
        switch self.maxRepeatCount {
        case .once:
            return self.currentRepeatCount >= 1
        case .finite(let maxCount):
            return self.currentRepeatCount >= maxCount
        case .infinite:
            return false
        }
    }
    
    var isLastFrame: Bool {
        return self.currentFrameIndex == self.frameCount - 1
    }
    
    var preloadingIsNeeded: Bool {
        return self.maxFrameCount < self.frameCount - 1
    }
    
    // MARK: 私有属性
    private let size: CGSize
    private let maxFrameCount: Int
    private let imageSource: CGImageSource
    private let maxRepeatCount: RepeatCount
    
    private let maxTimeStep: TimeInterval = 1.0
    
    private var animatedFrames: [AnimatedFrame] = [AnimatedFrame]()
    private var frameCount: Int = 0
    private var timeSinceLastFrameChange: TimeInterval = 0.0
    private var currentRepeatCount: UInt = 0
    
    private lazy var preloadQueue: DispatchQueue = {
        return DispatchQueue(label: "com.sibo.jian.JSAnimatedView.Animator.preloadQueue")
    }()
    
    // MARK: 初始化方法
    /// 通过图像源创建一个Animator实例对象
    ///
    /// - Parameters:
    ///   - source: 图像源
    ///   - mode: AnimatedImageView的内容模式
    ///   - size: AnimatedImageView的尺寸大小
    ///   - count: 预加载帧数数量
    ///   - repeatCount: 播放重复次数
    init(imageSource source: CGImageSource,
         contentMode mode: UIView.ContentMode,
         size: CGSize,
         framePreloadCount count: Int,
         repeatCount: RepeatCount,
         preloadQueue: DispatchQueue)
    {
        self.imageSource = source
        self.contentMode = mode
        self.size = size
        self.maxFrameCount = count
        self.maxRepeatCount = repeatCount
        self.preloadQueue = preloadQueue
    }

    // MARK: 公开方法
    func frame(at index: Int) -> UIImage? {
        return self.animatedFrames[safe: index]?.image
    }
    
    func duration(at index: Int) -> TimeInterval {
        return self.animatedFrames[safe: index]?.duration ?? .infinity
    }
    
    func prepareFramesAsynchronously() {
        self.frameCount = Int(CGImageSourceGetCount(self.imageSource))
        self.animatedFrames.reserveCapacity(self.frameCount)
        self.preloadQueue.async { [weak self] in
            self?.setupAnimatedFrames()
        }
    }
    
    func shouldChangeFrame(with duration: CFTimeInterval, handler: (Bool) -> Void) {
        self.incrementTimeSinceLastFrameChange(with: duration)
        
        if self.currentFrameDuration > self.timeSinceLastFrameChange {
            handler(false)
        }
        else {
            self.resetTimeSinceLastFrameChange()
            self.incrementCurrentFrameIndex()
            handler(true)
        }
    }
    
    // MARK: 私有方法
    private func setupAnimatedFrames() {
        self.resetAnimatedFrames()
        
        var duration: TimeInterval = 0.0
        
        (0..<self.frameCount).forEach { (index) in
            let frameDuration = GIFAnimatedImage.getFrameDuration(from: self.imageSource, at: index)
            duration += min(frameDuration, self.maxTimeStep)
            self.animatedFrames += [AnimatedFrame(image: nil, duration: frameDuration)]
            if index > self.maxFrameCount {
                return
            }
            self.animatedFrames[index] = self.animatedFrames[index].makeAnimatedFrame(image: self.loadFrame(at: index))
        }
        
        self.loopDuration = duration
    }
    
    private func resetAnimatedFrames() {
        self.animatedFrames = []
    }
    
    private func loadFrame(at index: Int) -> UIImage? {
        guard let image = CGImageSourceCreateImageAtIndex(self.imageSource, index, nil) else {
            return nil
        }
        
        let scaledImage: CGImage
        if self.needsPrescaling, self.size != .zero {
            scaledImage = image.resize(to: self.size, for: self.contentMode)
        }
        else {
            scaledImage = image
        }
        
        return UIImage(cgImage: scaledImage)
    }
    
    private func updatePreloadedFrames() {
        guard self.preloadingIsNeeded else {
            return
        }
        
        self.animatedFrames[self.previousFrameIndex] = self.animatedFrames[self.previousFrameIndex].placeholderFrame
        
        self.preloadIndexes(start: self.currentFrameIndex).forEach { (index) in
            let currentAnimatedFrame = self.animatedFrames[index]
            if !currentAnimatedFrame.isPlaceholder {
                return
            }
            self.animatedFrames[index] = currentAnimatedFrame.makeAnimatedFrame(image: self.loadFrame(at: index))
        }
    }
    
    private func incrementCurrentFrameIndex() {
        self.currentFrameIndex = self.increment(frameIndex: currentFrameIndex)
        if self.isReachMaxRepeatCount && self.isLastFrame {
            self.isFinished = true
        }
        else if self.currentFrameIndex == 0 {
            self.currentRepeatCount += 1
        }
    }
    
    private func incrementTimeSinceLastFrameChange(with duration: TimeInterval) {
        self.timeSinceLastFrameChange += min(self.maxTimeStep, duration)
    }
    
    private func resetTimeSinceLastFrameChange() {
        self.timeSinceLastFrameChange -= self.currentFrameDuration
    }
    
    private func increment(frameIndex: Int, by value: Int = 1) -> Int {
        return (frameIndex + value) % self.frameCount
    }
    
    private func preloadIndexes(start index: Int) -> [Int] {
        let nextIndex = self.increment(frameIndex: index)
        let lastIndex = self.increment(frameIndex: index, by: self.maxFrameCount)
        if lastIndex >= nextIndex {
            return [Int](nextIndex...lastIndex)
        }
        else {
            return [Int](nextIndex..<self.frameCount) + [Int](0...lastIndex)
        }
    }
}
