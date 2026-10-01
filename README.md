# iOS_Demo

个人 iOS 练习项目集合（Objective-C），一个仓库下放多个独立小项目。

## 运行前先看这里

`Pods/` 和 `.xcworkspace` **没有提交**（已在根目录 `.gitignore` 中忽略），
所以 clone 下来不能直接用 Xcode 打开，需要先装依赖。

### 一、使用 CocoaPods 的项目（12 个）

```bash
cd 项目目录
pod install
```

装完后**打开生成的 `.xcworkspace`**，不要直接打开 `.xcodeproj` ——
直接开 `.xcodeproj` 会因为找不到 Pods 而编译失败。

涉及项目：

| | |
|---|---|
| Spotify | Music |
| MVC | MVP模式 |
| Networking | NSURL |
| Share | WCDB_test |
| WeatherForecast | calculator |
| zara | 网络请求 |

> `Podfile.lock` 已提交，所以 `pod install` 装出来的版本和提交时**完全一致**，
> 不会出现"换个机器就编译不过"。注意用 `pod install`，不要用 `pod update`。

### 二、不使用 CocoaPods 的项目（3 个）

直接打开 `.xcodeproj` 即可，无需额外步骤：

`enum`、`GCD学习`、`RunLoop`

## 关于 Xcode 用户状态文件

`xcuserdata/`（窗口布局、断点、`UserInterfaceState` 等）是**本机专属**的，
每次打开 Xcode 都会变，已统一忽略，不会提交。

这类文件 clone 后由 Xcode **自动生成**，不需要手动恢复。

## 环境

- CocoaPods 1.16.2
- 各项目的最低系统版本见各自的 `Podfile` / Xcode 工程设置
