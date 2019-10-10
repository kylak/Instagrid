//
//  ViewController.swift
//  Instagrid
//
//  Created by Gustav Berloty on 03/10/2019.
//  Copyright © 2019 Gustav Berloty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var TopRightButton: UIButton!
    @IBOutlet weak var BottomRightButton: UIButton!
    
    @IBOutlet weak var Layout1Button: UIButton!
    @IBOutlet weak var Layout2Button: UIButton!
    @IBOutlet weak var Layout3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Layout1ButtonTouched(" (executed for a default view) ")
    }
    
    @IBAction func Layout1ButtonTouched(_ sender: Any) {
        if (Layout1Button.currentImage == nil) {
            removeButtonsImages()
            BottomRightButton.isHidden = false;
            Layout1Button.setImage(UIImage(named: "Selected"), for: UIControl.State.normal)
            TopRightButton.isHidden = true;
        }
    }
    
    @IBAction func Layout2ButtonTouched(_ sender: Any) {
        if (Layout2Button.currentImage == nil) {
            removeButtonsImages()
            TopRightButton.isHidden = false;
            Layout2Button.setImage(UIImage(named: "Selected"), for: UIControl.State.normal)
            BottomRightButton.isHidden = true;
        }
    }
    
    @IBAction func Layout3ButtonTouched(_ sender: Any) {
        if (Layout3Button.currentImage == nil) {
            removeButtonsImages()
            TopRightButton.isHidden = false;
            BottomRightButton.isHidden = false;
            Layout3Button.setImage(UIImage(named: "Selected"), for: UIControl.State.normal)
        }
    }
    
    func removeButtonsImages() {
        Layout1Button.setImage(nil, for: UIControl.State.normal)
        Layout2Button.setImage(nil, for: UIControl.State.normal)
        Layout3Button.setImage(nil, for: UIControl.State.normal)
    }
}

