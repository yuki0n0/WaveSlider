//
//  WaveSlider.swift
//  WaveSlider
//
//  Created by Yuki Ono on 2020/07/29.
//  Copyright © 2020 Yuki Ono. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
public class WaveSlider: UIView {
    
    private let minimumTrackView = UIView()
    private let maximumTrackView = UIView()
    private let layerShape = CAShapeLayer()
    
    private var bar: (width: CGFloat, space: CGFloat) = (3, 3)
    private var volumes: [Float] = []
    private var storedSize: CGSize = .zero
    private var constraintLeftWidth: NSLayoutConstraint!
    
    public private(set) var status: Status = .unknown
    
    @IBInspectable
    public var value: Float = 0 {
        didSet {
            value = value < 0 ? 0 : value > 1 ? 1 : value
            constraintLeftWidth.constant = bounds.width * CGFloat(value)
        }
    }
    
    @IBInspectable
    public var minimumTrackTintColor: UIColor? {
        get { return minimumTrackView.backgroundColor }
        set { minimumTrackView.backgroundColor = newValue }
    }
    
    @IBInspectable
    public var maximumTrackTintColor: UIColor? {
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
        
        minimumTrackView.backgroundColor = .systemBlue
        minimumTrackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(minimumTrackView)
        self.topAnchor.constraint(equalTo: minimumTrackView.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: minimumTrackView.leftAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: minimumTrackView.bottomAnchor).isActive = true
        self.constraintLeftWidth = minimumTrackView.widthAnchor.constraint(equalToConstant: 0)
        self.constraintLeftWidth.isActive = true
        
        maximumTrackView.backgroundColor = UIColor(white: 0.945, alpha: 1)
        maximumTrackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(maximumTrackView)
        self.topAnchor.constraint(equalTo: maximumTrackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: maximumTrackView.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: maximumTrackView.bottomAnchor).isActive = true
        maximumTrackView.leftAnchor.constraint(equalTo: minimumTrackView.rightAnchor).isActive = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if storedSize != bounds.size {
            storedSize = bounds.size
            setBars()
        }
    }
    
    public func set(url: URL, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            guard
                let file = try? AVAudioFile(forReading: url),
                let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))
                else {
                    self.status = .failed
                    completion?()
                    return
            }
            do {
                try file.read(into: buffer)
                self.volumes = buffer.volumes
            } catch {
                self.status = .failed
                completion?()
                return
            }
            
            DispatchQueue.main.async {
                self.setBars()
                self.status = .ready
                completion?()
            }
        }
    }
    
    private func setBars() {
        guard !volumes.isEmpty else { return }
        
        // バーをおける数
        let count = Int((bounds.width - bar.width) / (bar.width + bar.space)) + 1
        
        // 各バーの高さ(音量)
        let barVolumes = volumes.eachSlice(volumes.count / count).prefix(count).map({ $0.average() })
        let barVolumeRatios = barVolumes.map({ $0 / barVolumes.max()! })
        
        // パス
        let path = UIBezierPath()
        for (i, barVolumeRatio) in barVolumeRatios.enumerated() {
            var roundedRectHeight = bounds.height * CGFloat(barVolumeRatio)
            roundedRectHeight = roundedRectHeight < bar.width ? bar.width : roundedRectHeight
            let roundedRect = CGRect(x: (bar.width + bar.space) * CGFloat(i), y: (bounds.height - roundedRectHeight) / 2, width: bar.width, height: roundedRectHeight)
            path.append(UIBezierPath(roundedRect: roundedRect, cornerRadius: bar.width / 2.0))
        }
        layerShape.path = path.cgPath
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let count = Int((bounds.width - bar.width) / (bar.width + bar.space)) + 1
        volumes = (0..<count).map({ _ in Float.random(in: 0.3...1) })
        value = 0.2
        setBars()
    }
}

extension WaveSlider {
    
    public enum Status {
        case unknown
        case failed
        case ready
    }
}
