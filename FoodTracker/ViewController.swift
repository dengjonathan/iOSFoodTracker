//
//  ViewController.swift
//  FoodTracker
//
//  Created by Jonathan Deng on 5/21/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLabel.text = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // this guard statement safely unwraps the image contained in the info dictionary
        // if this value doesn't exist, it means our app is in an invalid state and should exit
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }

    // MARK: Actions
   
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let imageController = UIImagePickerController()
        
        // only allow photos from library, not camera
        imageController.sourceType = .photoLibrary
        
        // assign self (this viewController) as the imageController's delegate
        imageController.delegate = self
        // you can tag which arguments you're passing in
        // present method implicitly called on "self"
        present(imageController, animated: true, completion: nil)
    }
    @IBAction func setDefaultTextLabel(_ sender: UIButton) {
        // code inside this block will run when the button is clicked
        mealNameLabel.text = "hello jon"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // specify self as delegate for text field - i.e. eventhandler
        nameTextField.delegate = self
    }

}

