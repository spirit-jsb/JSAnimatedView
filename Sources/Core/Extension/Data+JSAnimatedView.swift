//
//  Data+JSAnimatedView.swift
//  JSAnimatedView
//
//  Created by Max on 2019/4/3.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension Data {
    
    // MARK: 公开属性
    /// 获取数据的图像格式
    var imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 8)
        (self as NSData).getBytes(&buffer, length: 8)
        if buffer == ImageFormat.HeaderData.PNG {
            return .PNG
        }
        else if buffer[0] == ImageFormat.HeaderData.JPEG_SOI[0] &&
            buffer[1] == ImageFormat.HeaderData.JPEG_SOI[1] &&
            buffer[2] == ImageFormat.HeaderData.JPEG_IF[0]
        {
            return .JPEG
        }
        else if buffer[0] == ImageFormat.HeaderData.GIF[0] &&
            buffer[1] == ImageFormat.HeaderData.GIF[1] &&
            buffer[2] == ImageFormat.HeaderData.GIF[2]
        {
            return .GIF
        }
        return .unknown
    }
}
