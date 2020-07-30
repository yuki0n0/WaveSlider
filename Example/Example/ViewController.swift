//
//  ViewController.swift
//  Example
//
//  Created by Yuki Ono on 2020/07/29.
//  Copyright © 2020 Yuki Ono. All rights reserved.
//

import UIKit
import AVFoundation
import WaveSlider

class ViewController: UIViewController {

    @IBOutlet weak var waveSlider: WaveSlider!
    @IBOutlet weak var button: UIButton!
    
    var player: AVPlayer!
    var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.isHidden = true
        
        let path = Bundle.main.path(forResource: "fanfare", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        
        player = AVPlayer(url: url)
        observation = player.currentItem?.observe(\.status) { [weak self] _, _ in self?.startIfPossible() }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let time = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let duration = self?.player.currentItem?.duration.seconds else { return }
            self?.waveSlider.value = Float(time.seconds / duration)
        }
        
        waveSlider.set(url: url) { [weak self] in self?.startIfPossible() }
    }
    
    @IBAction func play(_ sender: Any) {
        button.isHidden = true
        player.seek(to: .zero)
        player.play()
    }
    
    func startIfPossible() {
        guard player.currentItem?.status == .readyToPlay, waveSlider.status == .ready else { return }
        button.isHidden = false
    }
    
    @objc func playerDidFinishPlaying() {
        button.isHidden = false
    }
}
