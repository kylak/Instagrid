//
//  ViewController.swift
//  Instagrid
//
//  Created by Gustav Berloty on 03/10/2019.
//  Copyright © 2019 Gustav Berloty. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var ArrowToSwipe: UIImageView!
    @IBOutlet weak var TextToSwipeUp: UILabel!
    
    @IBOutlet weak var MainGridView: UIView!
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
    
    func defaultMainGridView() {
        Layout1ButtonTouched("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultMainGridView()
        MainGridView.heightAnchor.constraint(equalToConstant: MainGridView.frame.height).isActive = true // On fixe la taille de la grille à la taille du téléphone.
        view.removeConstraints([ConstraintToRemove, PortraitMainConstraint, LandscapeMainConstraint])
        ManageSwipeUpGesture()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        MainGridView.heightAnchor.constraint(equalToConstant: MainGridView.frame.height).isActive = true // On fixe la taille de la grille à la taille du téléphone.
        view.removeConstraints([ConstraintToRemove, PortraitMainConstraint, LandscapeMainConstraint])
    }
    
    func addSwipeGesture(to view: UIView, _ gesture_tab: [UISwipeGestureRecognizer.Direction]) {
        for direction in gesture_tab {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(Swipped(_:)))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
    }
    
    func ManageSwipeUpGesture() {
        addSwipeGesture(to: ArrowToSwipe, [.up, .left])
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
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { insertPickedImageIntoMainGrid(pickedImage) }
    }
    
    func insertPickedImageIntoMainGrid(_ image: UIImage) {
        buttonTouched.contentMode = .scaleAspectFit
        buttonTouched.setImage(image, for: UIControl.State.normal)
    }
    
    @objc func Swipped(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left && traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular || sender.direction == .up && traitCollection.verticalSizeClass == .compact) {
            return;
        }
        print("gesture received !")
        switch sender.state {
            case .ended:
                let items = [MainGridView.image] // MainGridView.image est l'image représentant la MainGrid, càd celle que l'on veut enregistrer.
                let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
                present(ac, animated: true)
            default: break;
        }
    }
    
}

extension UIView {
    // On étend la classe UIView avec une nouvelle propriété "image" comme screenshot. La méthode snapshotView() fournit par Apple renvoie un UIView non un UIImageView, utiliser snapshotView() nécessiterait donc en plus de caster la valeur de retour en UIImageView, la solution d'étendre la classe UIView est donc la plus simple et plus rapide solution trouvée.
    var image: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
}

// let rect = AVMakeRect(aspectRatio: buttonTouched.intrinsicContentSize, insideRect: buttonTouched.bounds)
