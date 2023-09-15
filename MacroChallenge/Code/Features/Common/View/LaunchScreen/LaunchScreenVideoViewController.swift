//
//  LaunchScreenVideoViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 15/09/23.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class LaunchScreenVideoViewController: UIViewController {
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
        self.view.backgroundColor = .SZColorBeige
    }

    private func loadVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "LaunchscreenVideo", ofType:"mov")
        

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        self.view.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openInitialVC), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

        player?.seek(to: CMTime.zero)
        player?.play()
   }
}


extension LaunchScreenVideoViewController {
    @objc func openInitialVC() {
        let newVC = TabBarViewController()
        
        newVC.modalPresentationStyle = .fullScreen
        
        self.present(newVC, animated: false)
    }
}
