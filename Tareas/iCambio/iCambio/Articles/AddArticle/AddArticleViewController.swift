//
//  AddArticleViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 02/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseFirestore

class AddArticleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var articleFirstImageView: UIImageView!
    @IBOutlet weak var articleSecondImageView: UIImageView!
    @IBOutlet weak var articleThirdImageView: UIImageView!
    @IBOutlet weak var articleNameTextField: UITextField!
    @IBOutlet weak var articleDescriptionTextView: UITextView!
    
    
    let disposeBag = DisposeBag()
    let articlesRepository = ArticlesRepository()
    var addArticlePresenter: AddArticlePresenter? = nil
    var spinnerView: UIView? = nil
    
    let imagePicker = UIImagePickerController()
    enum viewSelected: Int {
        case mainView = 1
        case leftView = 2
        case rightView = 3
    }
    
    var currentImageView = 1
    var imagesSelected: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addArticlePresenter = AddArticlePresenter(viewController: self)
        imagePicker.delegate = self
        articleNameTextField.delegate = self
        let tapFirst = UITapGestureRecognizer(target: self, action: #selector(AddArticleViewController.showActionSheetFirst))
        let tapSecond = UITapGestureRecognizer(target: self, action: #selector(AddArticleViewController.showActionSheetSecond))
        let tapThird = UITapGestureRecognizer(target: self, action: #selector(AddArticleViewController.showActionSheetThird))
        
        articleFirstImageView.addGestureRecognizer(tapFirst)
        articleFirstImageView.isUserInteractionEnabled = true
        
        articleSecondImageView.addGestureRecognizer(tapSecond)
        articleSecondImageView.isUserInteractionEnabled = true
        
        articleThirdImageView.addGestureRecognizer(tapThird)
        articleThirdImageView.isUserInteractionEnabled = true
        
        articleDescriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        articleDescriptionTextView.layer.borderWidth = 1.0
        articleDescriptionTextView.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        articleNameTextField.resignFirstResponder()
        return true
    }
    
    //: MARK
    @objc func showActionSheetFirst(){
        currentImageView = viewSelected.mainView.rawValue
        showActionSheet()
    }
    
    @objc func showActionSheetSecond(){
        currentImageView = viewSelected.leftView.rawValue
        showActionSheet()
    }
    
    @objc func showActionSheetThird(){
        currentImageView = viewSelected.rightView.rawValue
        showActionSheet()
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        if #available(iOS 11.0, *) {
            if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                print(imageURL)
                imagesSelected.append(imageURL.absoluteString)
            }
        } else {
            if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                print(imageUrl)
                imagesSelected.append(imageUrl.absoluteString)
            }
        }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            switch currentImageView {
            case viewSelected.mainView.rawValue:
                self.articleFirstImageView?.image = image
                break
            case viewSelected.leftView.rawValue:
                self.articleSecondImageView?.image = image
                break
            case viewSelected.rightView.rawValue:
                self.articleThirdImageView?.image = image
                break
            default:
                self.articleFirstImageView?.image = image
            }
        }else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func publishArticleClicked(_ sender: UIButton) {
        if let user = UserRepository().getCurrentFireUser() {
            let name = self.articleNameTextField.text
            let description = self.articleDescriptionTextView.text
            let article = Article(userUID: user.uid, name: name!, pictures: [], description: description! , offers: 0, available: true)
            
            if (imagesSelected.count < 1) {
                showErrorDialogDefault(title: "Ups!",message: "Debes publicar tu articulo con al menos una foto")
            } else if (name?.isEmpty)!{
                showErrorDialogDefault(title: "Ups!",message: "Tu articulo necesita un nombre")
            }else {
                addArticlePresenter?.publishArticle(article: article, imagesSelected:imagesSelected)
            }
        } else {
            let profileViewController: ProfileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    func toggle(loading: Bool) {
        if loading {
            spinnerView = displaySpinner(onView: self.view)
        } else {
            removeSpinner(spinner: spinnerView)
        }
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: private functions
    private func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    private func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            present(myPickerController, animated: true, completion: nil)
        }
    }
}
