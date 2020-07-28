//
//  AVAudioPCMBuffer+Extension.swift
//  WaveSlider
//
//  Created by Yuki Ono on 2020/07/29.
//  Copyright © 2020 Yuki Ono. All rights reserved.
//

import AVFoundation

extension AVAudioPCMBuffer {
    
    /// 各サンプルの音量を取得。
    var volumes: [Float] {
        guard let channelData = self.floatChannelData?[0] else { return [] }
        let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(frameLength)))
        
        var outEnvelope: [Float] = []
        var envelopeState: Float = 0
        let envConstantAtk: Float = 0.16
        let envConstantDec: Float = 0.003
        
        for sample in channelDataArray {
            let rectified = abs(sample)
            
            if envelopeState < rectified {
                envelopeState += envConstantAtk * (rectified - envelopeState)
            } else {
                envelopeState += envConstantDec * (rectified - envelopeState)
            }
            outEnvelope.append(envelopeState)
        }
        return outEnvelope
    }
}
