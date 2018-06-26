//
//  NewIdeaCollectionViewCell.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 19/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class NewIdeaCollectionViewCell: UICollectionViewCell {
    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 16
        
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.cgColor
        
//        view.layer.shadowColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
//        view.layer.shadowRadius = 1
//        view.layer.shadowOpacity = 0.3
//        view.layer.shadowOffset = CGSize.init(width: 3.0, height: 5.0)
        
    }

}
