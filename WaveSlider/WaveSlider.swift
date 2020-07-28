//
//  WaveSlider.swift
//  WaveSlider
//
//  Created by Yuki Ono on 2020/07/29.
//  Copyright © 2020 Yuki Ono. All rights reserved.
//

import UIKit
import AVFoundation

public class WaveSlider: UIView {
    
    private let minimumTrackView = UIView()
    private let maximumTrackView = UIView()
    private let layerShape = CAShapeLayer()
    private var volumes: [Float] = []
    
    private var constraintLeftWidth: NSLayoutConstraint!
    
    public var value: Float = 0 { didSet { constraintLeftWidth.constant = bounds.width * CGFloat(value) } }
    
    @IBInspectable var minimumTrackTintColor: UIColor? {
        get { return minimumTrackView.backgroundColor }
        set { minimumTrackView.backgroundColor = newValue }
    }
    
    @IBInspectable var maximumTrackTintColor: UIColor? {
        get { return maximumTrackView.backgroundColor }
        set { maximumTrackView.backgroundColor = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.layer.mask = layerShape
        
        minimumTrackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(minimumTrackView)
        self.topAnchor.constraint(equalTo: minimumTrackView.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: minimumTrackView.leftAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: minimumTrackView.bottomAnchor).isActive = true
        self.constraintLeftWidth = minimumTrackView.widthAnchor.constraint(equalToConstant: 0)
        self.constraintLeftWidth.isActive = true
        
        maximumTrackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(maximumTrackView)
        self.topAnchor.constraint(equalTo: maximumTrackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: maximumTrackView.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: maximumTrackView.bottomAnchor).isActive = true
        maximumTrackView.leftAnchor.constraint(equalTo: minimumTrackView.rightAnchor).isActive = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setBars()
    }
    
    public func set(url: URL) {
        guard
            let file = try? AVAudioFile(forReading: url),
            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false),
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length))
            else { return }
        try? file.read(into: buffer)
        self.volumes = buffer.volumes
        setBars()
    }
    
    private func setBars() {
        guard !volumes.isEmpty else { return }
        
        // バーをおける数
        let count = Int((bounds.width - 3) / 6) + 1
        
        // 各バーの高さ(音量)
        let barVolumes = volumes.eachSlice(volumes.count / count).prefix(count).map({ $0.max() ?? 0 })
        let barVolumeRatios = barVolumes.map({ $0 / barVolumes.max()! })
        
        // パス
        let path = UIBezierPath()
        for (i, barVolumeRatio) in barVolumeRatios.enumerated() {
            var roundedRectHeight = bounds.height * CGFloat(barVolumeRatio)
            roundedRectHeight = roundedRectHeight < 6 ? 6 : roundedRectHeight
            let roundedRect = CGRect(x: 6 * CGFloat(i), y: (bounds.height - roundedRectHeight) / 2, width: 3, height: roundedRectHeight)
            path.append(UIBezierPath(roundedRect: roundedRect, cornerRadius: 3.0 / 2.0))
        }
        layerShape.path = path.cgPath
    }
}
