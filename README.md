
# WaveSlider

## Installation

### CocoaPods

`Podfile` :

```ruby
pod 'WaveSlider'
```

### Carthage

`Cartfile` :

```
github "yuki0n0/WaveSlider"
```

## Usage

### Swift

```swift
import WaveSlider

let waveSlider = WaveSlider()
let path = Bundle.main.path(forResource: "music", ofType: "mp3")
let url = URL(fileURLWithPath: path!)
waveSlider.set(url: url)
waveSlider.value = 0.2

// Note: `url` of argument accepts only the local file path.
```

### Interface Builder (storyboard, xib)

1. Add UIView on Interface Builder (like .storyboard, .xib) and Set class and module `WaveSlider` .
2. Can edit color and value at right pane.
3. Finaly, You should connect to code and manipulate it.

|1|2|
| -- | -- |
|![](https://user-images.githubusercontent.com/10773910/89126425-8b3e3100-d520-11ea-88b8-0a2790eb588b.png)|![](https://user-images.githubusercontent.com/10773910/89126428-8f6a4e80-d520-11ea-99c2-d241bb10154b.png)|


## Getting ready

- [ ] README の拡充
  - [ ] 日本語も用意する
  - [ ] IB の説明を GIF にする
- [ ] テストとCI
- [ ] タップしてスライドできるように
  - [ ] IB からもよびだせるように。valuechanged で
- [ ] ローカルファイルのみ対応な部分の修正 (そもそも引数を AVAudioFile にしたほうがいいかも)
- [ ] 継承を UIControl にしなければ
- [ ] UIカスタマイズ
  - [ ] bar の幅と間隔
  - [ ] padding
  - [ ] 角丸か否かの選択
- [ ] ライブラリ
  - [ ] Swifty Package Manager
  - [ ] Manual
- [ ] バグ修正
  - [ ] 音声が短すぎるとバーが表示できない