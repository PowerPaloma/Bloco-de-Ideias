//
//  MyIdeaCollectionViewCell.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 15/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class MyIdeaCollectionViewCell: UICollectionViewCell {
    @IBOutlet var view: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var tags: UIStackView!
    @IBOutlet var image: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        image.layer.shadowOpacity = 0.8
        image.layer.shadowRadius = 4.0
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            image.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = image.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(blurEffectView, at: 1)
        } else {
            view.backgroundColor = .black
        }
    }
    
    //---------------- collection view cell -------------
    func startWiggling() {
        guard view.layer.animation(forKey: "wiggle") == nil else { return }
        guard view.layer.animation(forKey: "bounce") == nil else { return }
        
        let angle = 0.04
        
        let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        wiggle.values = [-angle, angle]
        
        wiggle.autoreverses = true
        wiggle.duration = randomInterval(interval: 0.2, variance: 0.030)
        wiggle.repeatCount = Float.infinity
        
        contentView.layer.add(wiggle, forKey: "wiggle")
        
//        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
//        bounce.values = [4.0, 0.0]
//
//        bounce.autoreverses = true
//        bounce.duration = randomInterval(interval: 0.12, variance: 0.025)
//        bounce.repeatCount = Float.infinity
//
//        contentView.layer.add(bounce, forKey: "bounce")
    }
    
    func stopWiggling() {
        contentView.layer.removeAllAnimations()
    }
    
    func randomInterval(interval: TimeInterval, variance: Double) -> TimeInterval {
        return interval + variance * Double((Double(arc4random_uniform(1000)) - 500.0) / 500.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopWiggling()
    }
    //-----------------------------
    
    
}
