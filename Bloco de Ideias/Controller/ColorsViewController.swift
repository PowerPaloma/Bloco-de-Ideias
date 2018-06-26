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
    var currentColor = UIColor()
    var delegate : ColorsDelegate!
    
    @IBOutlet var btnYellow: UIButton!
    @IBOutlet var btnBlue: UIButton!
    @IBOutlet var btnGreen: UIButton!
    @IBOutlet var btnPink: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastColorUsed = btnYellow
        
        btnYellow.setImage(#imageLiteral(resourceName: "color_yellow_selected"), for: .selected)
        btnBlue.setImage(#imageLiteral(resourceName: "color_blue_selected"), for: .selected)
        btnGreen.setImage(#imageLiteral(resourceName: "color_green_selected"), for: .selected)
        btnPink.setImage(#imageLiteral(resourceName: "color_pink_selected"), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if currentColor == UIColor.yellow {
            btnYellow.isSelected = true
        } else if currentColor == UIColor.blue {
            btnBlue.isSelected = true
        } else if currentColor == UIColor.green {
            btnGreen.isSelected = true
        } else if currentColor == UIColor.pink {
            btnPink.isSelected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bgYellow(_ sender: UIButton) {
        changeButtonState(sender)
        currentColor = .yellow
        delegate.newBgColorDrawView(.yellow)
    }
    
    
    @IBAction func bgBlue(_ sender: UIButton) {
        changeButtonState(sender)
        currentColor = .blue
        delegate.newBgColorDrawView(.blue)
    }
    
    @IBAction func bgGreen(_ sender: UIButton) {
        changeButtonState(sender)
        currentColor = .green
        delegate.newBgColorDrawView(.green)
    }
    
    @IBAction func bgPink(_ sender: UIButton) {
        changeButtonState(sender)
        currentColor = .pink
        delegate.newBgColorDrawView(.pink)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeButtonState(_ button:UIButton){
        lastColorUsed.isSelected = false
        button.isSelected = true
        lastColorUsed = button
    }
}
