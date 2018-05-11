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

class AddArticleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var articleFirstImageView: UIImageView!
    @IBOutlet weak var articleSecondImageView: UIImageView!
    @IBOutlet weak var articleThirdImageView: UIImageView!
    @IBOutlet weak var articleNameTextField: UITextField!
    @IBOutlet weak var priceRangePicker: UIPickerView!
    
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
    let maxPrice = 10000
    var priceRanges: [(min: Int, max:Int)] {
        var tempPR: [(min: Int, max:Int)] = []
        for minPrice in stride(from: 0, to: maxPrice, by: 100) {
            tempPR.append((min: minPrice, max: (minPrice + 100)))
        }
        return tempPR
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addArticlePresenter = AddArticlePresenter(viewController: self)
        imagePicker.delegate = self
        priceRangePicker.delegate = self
        priceRangePicker.dataSource = self
        let tapFirst = UITapGestureRecognizer(target: self, action: #selector(AddArticleViewController.showActionSheetFirst))
        let tapSecond = UITapGestureRecognizer(target: self, action: #selector(AddArticleViewController.showActionSheetSecond))
        let tapThird = UITapGestureRecognizer(target: self, action: #selector(AddArticleViewController.showActionSheetThird))
        
        articleFirstImageView.addGestureRecognizer(tapFirst)
        articleFirstImageView.isUserInteractionEnabled = true
        
        articleSecondImageView.addGestureRecognizer(tapSecond)
        articleSecondImageView.isUserInteractionEnabled = true
        
        articleThirdImageView.addGestureRecognizer(tapThird)
        articleThirdImageView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let name = self.articleNameTextField.text
        let minPrice = self.priceRanges[self.priceRangePicker.selectedRow(inComponent: 0)].min
        let maxPrice = self.priceRanges[self.priceRangePicker.selectedRow(inComponent: 0)].max
        let article = Article(userUID: "sin_asignar", name: name!, pictures: [], minPrice: minPrice, maxPrice: maxPrice, offers: 0, available: true)
        
        if (imagesSelected.count < 1) {
            showErrorDialogDefault(title: "Ups!",message: "Debes publicar tu articulo con al menos una foto")
        } else if (name?.isEmpty)!{
            showErrorDialogDefault(title: "Ups!",message: "Tu articulo necesita un nombre")
        }else {
            addArticlePresenter?.publishArticle(article: article, imagesSelected:imagesSelected)
        }
    }
    
    func toggle(loading: Bool) {
        if loading {
            spinnerView = UIViewController.displaySpinner(onView: self.view)
        } else {
            UIViewController.removeSpinner(spinner: spinnerView)
        }
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priceRanges.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "$\(priceRanges[row].min) - $\(priceRanges[row].max)"
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
