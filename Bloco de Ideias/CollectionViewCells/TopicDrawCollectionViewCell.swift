//
//  TopicImageCollectionViewCell.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 20/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class TopicDrawCollectionViewCell: UICollectionViewCell {
    @IBOutlet var view: UIView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var viewBlur: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = #colorLiteral(red: 0.4390000105, green: 0.4390000105, blue: 0.4390000105, alpha: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.init(width: 3.0, height: 5.0)
        
        deleteButton.layer.isHidden = true
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            viewBlur.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = CGRect(origin: viewBlur.frame.origin, size: viewBlur.bounds.size)
            
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(blurEffectView, at: 1)
        } else {
            view.backgroundColor = .black
        }
    }
    
    //---------------- Wiggling -------------
    func startWiggling() {
        guard view.layer.animation(forKey: "wiggle") == nil else { return }
        guard view.layer.animation(forKey: "bounce") == nil else { return }
        
        deleteButton.layer.isHidden = false
        let angle = 0.04
        
        //--- wiggle
        let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        wiggle.values = [-angle, angle]
        
        wiggle.autoreverses = true
        wiggle.duration = randomInterval(interval: 0.2, variance: 0.030)
        wiggle.repeatCount = Float.infinity
        
        contentView.layer.add(wiggle, forKey: "wiggle")
        
        //--- bounce
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.values = [4.0, 0.0]
        
        bounce.autoreverses = true
        bounce.duration = randomInterval(interval: 0.12, variance: 0.025)
        bounce.repeatCount = Float.infinity
        
        contentView.layer.add(bounce, forKey: "bounce")
    }
    
    func stopWiggling() {
        deleteButton.layer.isHidden = true
        contentView.layer.removeAllAnimations()
    }
    
    func randomInterval(interval: TimeInterval, variance: Double) -> TimeInterval {
        return interval + variance * Double((Double(arc4random_uniform(1000)) - 500.0) / 500.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopWiggling()
    }
    
}
