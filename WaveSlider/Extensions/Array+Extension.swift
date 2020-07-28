//
//  Array+Extension.swift
//  WaveSlider
//
//  Created by Yuki Ono on 2020/07/29.
//  Copyright © 2020 Yuki Ono. All rights reserved.
//

extension Array {
    
    func eachSlice(_ n: Int) -> [ArraySlice<Element>] {
        guard n != 0 else { return [] }
        return stride(from: 0, through: count - 1, by: n).map({ self[($0..<$0+n).clamped(to: indices)] })
    }
}
