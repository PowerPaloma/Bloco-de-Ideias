//
//  NewTopicCollectionViewCell.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 25/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class NewTopicCollectionViewCell: UICollectionViewCell {

    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 16
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        
        view.layer.shadowColor = #colorLiteral(red: 0.4390000105, green: 0.4390000105, blue: 0.4390000105, alpha: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.init(width: 3.0, height: 5.0)
    }

}
