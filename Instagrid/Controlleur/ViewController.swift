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
    @IBOutlet weak var TextToSwipeLeft: UILabel!
    
    @IBOutlet weak var MainGridView: UIView!
    
    @IBOutlet weak var TopLeftButton: UIButton!
    @IBOutlet weak var BottomLeftButton: UIButton!
    @IBOutlet weak var TopRightButton: UIButton!
    @IBOutlet weak var BottomRightButton: UIButton!
    
    // The 3 buttons to choose the main grid's layout.
    @IBOutlet weak var Layout1Button: UIButton!
    @IBOutlet weak var Layout2Button: UIButton!
    @IBOutlet weak var Layout3Button: UIButton!
    
    // The variable used to pick an image from the user's photo library.
    var buttonTouched = UIButton()
    var imagePicker = UIImagePickerController()
    
    
    func defaultMainGridView() {
        Layout1ButtonTouched("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultMainGridView()
        ManageSwipeUpGesture()
    }
    
    
    // "Changing the layout" part ----
    
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
    // End of "Changing the layout" part
    
    
    // Image insertion part ----
    
    @IBAction func GridButtonTouched(_ sender: UIButton) {
        takeAPhoto()
        buttonTouched = sender
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
    // End of "Image insertion part"
    
    
    // Swipe part ----
    
    func ManageSwipeUpGesture() {
        addSwipeGesture(to: ArrowToSwipe, [.up, .left])
        addSwipeGesture(to: TextToSwipeUp, [.up])
        addSwipeGesture(to: TextToSwipeLeft, [.left])
        addSwipeGesture(to: MainGridView, [.up, .left])
    }
    
    func addSwipeGesture(to view: UIView, _ gesture_tab: [UISwipeGestureRecognizer.Direction]) {
        for direction in gesture_tab {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(Swiped(_:)))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
    }
    
    func isSwipeValid(_ sender: UISwipeGestureRecognizer) -> Bool {
        return (sender.direction == .left && traitCollection.verticalSizeClass == .compact) || (sender.direction == .up && traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .compact)
    }
    
    @objc func Swiped(_ sender: UISwipeGestureRecognizer) {
        if isSwipeValid(sender) {
            var translation = CGAffineTransform();
            if (sender.direction == .up) {
                translation = CGAffineTransform(translationX: 0, y: -MainGridView.frame.maxY)
            }
            else if (sender.direction == .left) {
                translation = CGAffineTransform(translationX: -MainGridView.frame.maxX, y: 0)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                self.MainGridView.transform = translation
                },
                completion: { (end) in
                    let share = self.getTheMainGridImageReadyToShare(sender);
                    self.present(share, animated: true);
                }
            )
        }
    }
    
    func getTheMainGridImageReadyToShare(_ sender: UISwipeGestureRecognizer) -> UIActivityViewController {
        let image = [self.MainGridView.image] // MainGridView.image est l'image représentant la MainGrid, càd celle que l'on veut enregistrer.
        let activityViewController = UIActivityViewController(activityItems: image as [Any], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = UIActivityViewController.CompletionWithItemsHandler? { activityType,completed,returnedItems,activityError in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                self.MainGridView.transform = CGAffineTransform(translationX: 0, y: 0)
                },
                completion: nil
            )
        }
        return activityViewController
    }
    
    // End of the "Swipe part".
    
}

extension UIView {
    // On étend la classe UIView avec une nouvelle propriété "image" comme screenshot. La méthode snapshotView() fournit par Apple renvoie un UIView non un UIImageView, utiliser snapshotView() nécessiterait donc en plus de caster la valeur de retour en UIImageView, la solution d'étendre la classe UIView est donc la plus simple et la plus rapide trouvée.
    var image: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
}
