# JSAnimatedView

<p align="center">
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/language-swift-red.svg"></a>
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/swift%20version-5.0-orange.svg"></a>
<a href="https://github.com/spirit-jsb/JSAnimatedView/"><img src="https://img.shields.io/cocoapods/v/JSAnimatedView.svg?style=flat"></a>
<a href="https://github.com/spirit-jsb/JSAnimatedView/blob/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/JSAnimatedView.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/JSAnimatedView"><img src="https://img.shields.io/cocoapods/p/JSAnimatedView.svg?style=flat"></a>
</p>

## 示例代码

如需要运行示例项目，请 `clone` 当前 `repo` 到本地，并且从根目录下执行 `JSAnimatedView.xcworkspace`，打开项目后切换 `Scheme` 至 `JSAnimatedView-Demo` 即可。

## 基本使用

设置其他类型图片与`UIImage`方法相同。

设置`GIF`图像请使用如下方法：

```swift
func animate(withGIFNamed imageName: String, options: ImageCreatingOptions? = nil)
    
func animate(withGIFData imageData: Data, options: ImageCreatingOptions? = nil)
```

其中`ImageCreatingOptions`设置内容如下：

```swift
/// 需要创建图像的目标比例
let scale: CGFloat
    
/// 如果创建动画图像，预期的动画持续时间
let duration: TimeInterval

/// 如果创建动画图像，是否预先加载所有帧信息
let preloadAll: Bool

/// 如果创建动画图像，是否预览第一帧图像
let onlyFirstFrame: Bool
```

## Swift 版本依赖
| Swift | JSAnimatedView |
| ------| ---------------|
| 4.2   | >= 1.0.0       |
| 5.0   | >= 1.1.0       |

## 限制条件
* **iOS 9.0** and Up
* **Xcode 10.0** and Up
* **Swift Version = 5.0**

## 安装

`JSAnimatedView` 可以通过 [CocoaPods](https://cocoapods.org) 获得。安装只需要在你项目的 `Podfile` 中添加如下字段：

```ruby
pod 'JSAnimatedView', '~> 1.1.0'
```

## 作者

spirit-jsb, sibo_jian_29903549@163.com

## 许可文件

`JSAnimatedView` 可在 `MIT` 许可下使用，更多详情请参阅许可文件。