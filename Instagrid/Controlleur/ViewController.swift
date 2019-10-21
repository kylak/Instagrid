//
//  ViewController.swift
//  Instagrid
//
//  Created by Gustav Berloty on 03/10/2019.
//  Copyright © 2019 Gustav Berloty. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var ArrowToSwipe: UIImageView!
    @IBOutlet weak var TextToSwipeUp: UILabel!
    
    @IBOutlet weak var MainGridView: UIView!
    @IBOutlet weak var TitleView: UILabel!
    @IBOutlet weak var PortraitMainConstraint: NSLayoutConstraint! // PortraitMainConstraint = Safe Area.trailing ≥ MainGrid View.trailing + 30
    @IBOutlet weak var LandscapeMainConstraint: NSLayoutConstraint! // LandscapeMainConstraint = MainGrid View.top ≥ Title.bottom + 30
    
    @IBOutlet weak var ConstraintToRemove: NSLayoutConstraint!
    
    @IBOutlet weak var TopLeftButton: UIButton!
    @IBOutlet weak var BottomLeftButton: UIButton!
    @IBOutlet weak var TopRightButton: UIButton!
    @IBOutlet weak var BottomRightButton: UIButton!
    
    // The 3 buttons to choose the main grid's layout.
    @IBOutlet weak var Layout1Button: UIButton!
    @IBOutlet weak var Layout2Button: UIButton!
    @IBOutlet weak var Layout3Button: UIButton!
    
    // The variable used to pick an image from the user's photo library.
    var imagePicker = UIImagePickerController()
    var buttonTouched = UIButton()
    var PortraitModeInitializedFirst = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultMainGridView()
        finishDesign()
        ManageSwipeUpGesture()
    }
    
    func finishDesign() {
        if (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) {
            ConstraintToRemove.isActive = false
            PortraitMainConstraint = view.trailingAnchor.constraint(equalTo: MainGridView.layoutMarginsGuide.trailingAnchor, constant: view.bounds.width - MainGridView.bounds.width)
            print(view.bounds.width - MainGridView.bounds.width)
            LandscapeMainConstraint.isActive = false
            PortraitMainConstraint.isActive = true
            PortraitModeInitializedFirst = true
        }
        /*else if (traitCollection.verticalSizeClass == .compact) {
            PortraitMainConstraint.isActive = false
            LandscapeMainConstraint = MainGridView.topAnchor.constraint(equalTo: TitleView.layoutMarginsGuide.bottomAnchor, constant: MainGridView.bounds.minY - TitleView.bounds.maxY)
            LandscapeMainConstraint.isActive = true
            PortraitModeInitializedFirst = false
        }*/
    }
    
    /*override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (!PortraitModeInitializedFirst && self.view.traitCollection.verticalSizeClass == .compact) {
            finishDesign()
        }
        if (self.view.traitCollection.verticalSizeClass == .compact) {
            PortraitMainConstraint?.isActive = false
            LandscapeMainConstraint?.isActive = true
        }
        else if (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) {
            LandscapeMainConstraint?.isActive = false
            PortraitMainConstraint?.isActive = true
        }
    }*/
    
    func defaultMainGridView() {
        Layout1ButtonTouched("")
    }
    
    func ManageSwipeUpGesture() {
        let SwipeUpGestureForArrow = UISwipeGestureRecognizer(target: self, action: #selector(Swipped(_:)))
        SwipeUpGestureForArrow.direction = UISwipeGestureRecognizer.Direction.up
        ArrowToSwipe.addGestureRecognizer(SwipeUpGestureForArrow)
        let SwipeUpGestureForText = UISwipeGestureRecognizer(target: self, action: #selector(Swipped(_:)))
        SwipeUpGestureForText.direction = UISwipeGestureRecognizer.Direction.up
        TextToSwipeUp.addGestureRecognizer(SwipeUpGestureForText)
    }
    
    @IBAction func Layout1ButtonTouched(_ sender: Any) {
        if (Layout1Button.currentImage == nil) {
            removeButtonsImages()
            BottomRightButton.isEnabled = true;
            BottomRightButton.isHidden = false;
            Layout1Button.setImage(UIImage(named: "Selected"), for: UIControl.State.normal)
            TopRightButton.isEnabled = false;
            TopRightButton.isHidden = true;
        }
    }
    
    @IBAction func Layout2ButtonTouched(_ sender: Any) {
        if (Layout2Button.currentImage == nil) {
            removeButtonsImages()
            TopRightButton.isEnabled = true;
            TopRightButton.isHidden = false;
            Layout2Button.setImage(UIImage(named: "Selected"), for: UIControl.State.normal)
            BottomRightButton.isEnabled = false;
            BottomRightButton.isHidden = true;
        }
    }
    
    @IBAction func Layout3ButtonTouched(_ sender: Any) {
        if (Layout3Button.currentImage == nil) {
            removeButtonsImages()
            TopRightButton.isEnabled = true;
            BottomRightButton.isEnabled = true;
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
    
    @IBAction func TopLeftButtonTouched(_ sender: Any) {
        takeAPhoto()
        buttonTouched = TopLeftButton
    }
    
    @IBAction func TopRightButtonTouched(_ sender: Any) {
        takeAPhoto()
        buttonTouched = TopRightButton
    }
    
    @IBAction func BottomLeftButtonTouched(_ sender: Any) {
        takeAPhoto()
        buttonTouched = BottomLeftButton
    }
    
    @IBAction func BottomRightButtonTouched(_ sender: Any) {
        takeAPhoto()
        buttonTouched = BottomRightButton
    }
    
    func takeAPhoto() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            buttonTouched.contentMode = .scaleAspectFit
            buttonTouched.setImage(image, for: UIControl.State.normal)
        }
    }
    
    @objc func Swipped(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
            case .ended:
                // créer la nouvelle image a sauvegardé.
                let items = [ TopLeftButton.imageView?.image! ]
                let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
                present(ac, animated: true)
            default: break;
        }
    }
    
}

