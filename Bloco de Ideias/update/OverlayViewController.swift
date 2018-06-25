//
//  OverlayViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 25/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    
    @IBAction func dismissed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
}
