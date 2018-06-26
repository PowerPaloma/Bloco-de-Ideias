//
//  ColorsViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 26/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class ColorsViewController: UIViewController {

    var lastColorUsed = UIButton()
    var currentColor = UIColor.yellow
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func bgYellow(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "color_yellow_selected"), for: .selected)
        changeButtonState(sender)
        currentColor = .yellow
    }
    
    
    @IBAction func bgBlue(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "color_blue_selected"), for: .selected)
        changeButtonState(sender)
        currentColor = .blue
    }
    
    @IBAction func bgGreen(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "color_green_selected"), for: .selected)
        changeButtonState(sender)
        currentColor = .green
    }
    
    @IBAction func bgPink(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "color_pink_selected"), for: .selected)
        changeButtonState(sender)
        currentColor = .pink
    }
    
    func changeButtonState(_ button:UIButton){
        lastColorUsed.isSelected = false
        button.isSelected = true
        lastColorUsed = button
    }
}

extension ColorsViewController : ColorsDelegate {
    func newBgColorDrawView() -> UIColor{
        return self.currentColor
    }
}
