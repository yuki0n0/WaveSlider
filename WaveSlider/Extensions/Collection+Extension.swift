//
//  Collection+Extension.swift
//  WaveSlider
//
//  Created by Yuki Ono on 2020/07/31.
//  Copyright © 2020 Yuki Ono. All rights reserved.
//

extension Collection where Element: BinaryFloatingPoint {
    
    func average() -> Element {
        isEmpty ? .zero : Element(reduce(.zero, +)) / Element(count)
    }
}
