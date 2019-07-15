//
//  SettingsController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 14/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import JGProgressHUD

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as! CustomImagePickerController).imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, error) in
            if let error = error {
                hud.dismiss()
                print("Failed to upload image to storage:", error)
                return
            }
            ref.downloadURL(completion: { (url, error) in
                hud.dismiss()
                if let error = error {
                    print("Failed to retrieve download url:", error)
                    return
                }
                switch imageButton {
                case self.image1Button:
                    self.user?.imageUrl1 = url?.absoluteString
                case self.image2Button:
                    self.user?.imageUrl2 = url?.absoluteString
                default:
                    self.user?.imageUrl3 = url?.absoluteString
                }
            })
        }
    }
}

class SettingsController: UITableViewController {
    fileprivate let padding: CGFloat = 16
    fileprivate var user: User?
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var header: UIView = {
        let header = UIView()
        let verticalStackView = VerticalStackView(arrangedSubviews: [
            image2Button, image3Button
            ], spacing: padding)
        verticalStackView.distribution = .fillEqually
        let stackView = UIStackView(arrangedSubviews: [
            image1Button, verticalStackView
            ], customSpacing: padding)
        stackView.distribution = .fillEqually
        header.addSubview(stackView)
        stackView.addConsctraints(header.leadingAnchor, header.trailingAnchor, header.topAnchor, header.bottomAnchor, .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupTableView()
        fetchCurrentUser()
    }
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let dictionary = documentSnapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    @discardableResult
    fileprivate func loadImageIntoButton(_ url: URL, _ button: UIButton) -> SDWebImageCombinedOperation? {
        return SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            guard let image = image else { return }
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1,  let url = URL(string: imageUrl) {
            loadImageIntoButton(url, image1Button)
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            loadImageIntoButton(url, image2Button)
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            loadImageIntoButton(url, image3Button)
        }
    }
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel(text: "", font: .boldSystemFont(ofSize: 18))
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let cell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            cell.minLabel.text = "Min: \(user?.minSeekingAge ?? 18)"
            cell.maxLabel.text = "Max: \(user?.maxSeekingAge ?? 100)"
            cell.minSlider.value = Float(user?.minSeekingAge ?? 18)
            cell.maxSlider.value = Float(user?.maxSeekingAge ?? 100)
            cell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            cell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            return cell
        }
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell else { return }
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        if slider.value >= ageRangeCell.maxSlider.value {
            ageRangeCell.maxSlider.value = slider.value
            handleMaxAgeChange(slider: slider)
        }
        user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell else { return }
        if slider.value < ageRangeCell.minSlider.value {
            slider.value = ageRangeCell.minSlider.value
            return
        }
        ageRangeCell.maxLabel.text = "Min: \(Int(slider.value))"
        user?.maxSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let documentData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "profession": user?.profession ?? "",
            "age": user?.age ?? -1,
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "minSeekingAge": user?.minSeekingAge ?? 18,
            "maxSeekingAge": user?.maxSeekingAge ?? 100
        ]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Profiel"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
            hud.dismiss()
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    @objc fileprivate func handleSelectPhoto(sender: UIButton) {
        let imagePickerController = CustomImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageButton = sender
        present(imagePickerController, animated: true)
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
}
