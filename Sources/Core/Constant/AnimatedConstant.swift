//
//  AnimatedConstant.swift
//  JSAnimatedView
//
//  Created by Max on 2019/3/28.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

/// 表示如何调整自身尺寸以适应视图尺寸。
///
/// - none: 不缩放内容
/// - aspectFit: 通过保持宽高比来缩放内容以适应视图尺寸
/// - aspectFill: 缩放内容以填充视图尺寸
enum ContentMode {
    case none           /// 不缩放内容
    case aspectFit      /// 通过保持宽高比来缩放内容以适应视图尺寸
    case aspectFill     /// 缩放内容以填充视图尺寸
}

/// 表示图像格式
///
/// - unknown: 无法识别或不支持的图像格式
/// - PNG: PNG图像格式
/// - JPEG: JPEG图像格式
/// - GIF: GIF图像格式
enum ImageFormat {
    case unknown    /// 无法识别或不支持的图像格式
    case PNG        /// PNG图像格式
    case JPEG       /// JPEG图像格式
    case GIF        /// GIF图像格式
    
    struct HeaderData {
        static var PNG: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        static var JPEG_SOI: [UInt8] = [0xFF, 0xD8]
        static var JPEG_IF: [UInt8] = [0xFF]
        static var GIF: [UInt8] = [0x47, 0x49, 0x46]
    }
}

/// 指定GIF播放重复次数
public enum RepeatCount: Equatable {
    case once
    case finite(count: UInt)
    case infinite
    
    public static func ==(lhs: RepeatCount, rhs: RepeatCount) -> Bool {
        switch (lhs, rhs) {
        case let (.finite(l), .finite(count: r)):
            return l == r
        case (.once, .once), (.infinite, .infinite):
            return true
        case (.once, .finite(let count)), (.finite(let count), .once):
            return count == 1
        case (.once, _), (.infinite, _), (.finite, _):
            return false
        }
    }
}
