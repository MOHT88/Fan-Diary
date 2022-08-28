//
//  NewClubTableViewController.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 26.08.2022.
//

import UIKit

class NewClubTableViewController: UITableViewController {
    
   
    
    @IBOutlet weak var clubImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var clubNameTF: UITextField!
    @IBOutlet weak var stadiumNameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        saveButton.isEnabled = false
        
        clubNameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
       
    }
// MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    func saveNewClub() {
        
        
        let imageData = clubImage.image?.pngData()
        
        
        let newClub = Club(clubName: clubNameTF.text!, stadium: stadiumNameTF.text, location: locationTF.text, imageData: imageData)

        StorageManager.saveObject(newClub)
        
//        newClub.clubName = clubNameTF.text!
//        newClub.location = locationTF.text
//        newClub.stadium = stadiumNameTF.text
//        newClub.imageData = imageData
//        newClub = Club(clubName: clubNameTF.text!,
//                       stadium: stadiumNameTF.text,
//                       location: locationTF.text,
//                       image: clubImage.image,
//                       clubImage: nil)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}


extension NewClubTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if clubNameTF.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: Work with image

extension NewClubTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
     
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
            
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        clubImage.image = info[.editedImage] as? UIImage
        clubImage.contentMode = .scaleAspectFill
        clubImage.clipsToBounds = true
        dismiss(animated: true)
        
    }
}
