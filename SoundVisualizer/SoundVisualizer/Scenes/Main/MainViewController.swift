//
//  MainViewController.swift
//  SoundVisualizer
//
//  Created by Nguyen Duc Huy on 4/11/20.
//  Copyright © 2020 sun. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIStackView!
    
    private let numberOfSamples: Int = 10
    private var arrConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting containerView
        containerView.spacing = 4
        containerView.axis = .horizontal
        containerView.distribution = .equalSpacing
        containerView.alignment = .center
        
        // Add barView to containerView
        for _ in 1...numberOfSamples {
            setupView()
        }
        
        // Create object of microphone monitor and add observer
        let mic = MicrophoneMonitor(numberOfSamples: self.numberOfSamples)
        
        mic.notificationCenter.addObserver(forName: NotificationKey.microNotificationKey, usingBlock: { (name, data) in
            guard let data = data as? [Float] else { return }
            self.config(data)
        })
    }
    
    @objc
    private func config(_ soundSamples: [Float]) {
        for (index, level) in soundSamples.enumerated() {
            print(self.normalizeSoundLevel(level: level))
            arrConstraints[index].constant = self.normalizeSoundLevel(level: level)
        }
        self.containerView.layoutIfNeeded()
    }
    
    private func setupView() {
        let barView = UIView()
        let width = (containerView.frame.width - CGFloat(numberOfSamples - 1) * 4) / CGFloat(numberOfSamples)
        barView.backgroundColor = UIColor.orange
        barView.layer.cornerRadius = width / 2
        barView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: barView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        let heightConstraint = NSLayoutConstraint(item: barView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
        
        containerView.addArrangedSubview(barView)
        containerView.addConstraints([widthConstraint,heightConstraint])
        arrConstraints.append(heightConstraint)
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        guard level < 0 else { return CGFloat(0.1 * 300 / 25) } // Check if level start
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
}
