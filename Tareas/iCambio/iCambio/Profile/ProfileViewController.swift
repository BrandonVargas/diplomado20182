//
//  SecondViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 10/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase
import CodableFirebase
import RxSwift
import Kingfisher

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    let userImageURLCacheKey = "user_image"
    
    let disposeBag = DisposeBag()
    var userRepository: UserRepository? = nil
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUser()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.center = view.center
        loginButton.delegate = self as LoginButtonDelegate
        view.addSubview(loginButton)
    }
    
    func prepareUser() {
        userRepository = UserRepository()
        
        userRepository?.fetchCurrentUser().subscribe(onNext: { user in
            self.currentUser = user
            self.toogleProfileVisibility(isHidden: false)
        }, onError: { error in
            self.showErrorDialogDefault(title: "Ups!", message: error.localizedDescription)
        }).disposed(by: disposeBag)
        
        userRepository?.userSubject.subscribe(onNext: { currentUser in
            self.currentUser = currentUser
            self.toogleProfileVisibility(isHidden: false)
        }, onError: { error in
            self.showLoginError(error)
        }).disposed(by: disposeBag)
        
        if (currentUser != nil) {
            toogleProfileVisibility(isHidden: false)
        } else {
            toogleProfileVisibility(isHidden: true)
        }
    }
    
    func toogleProfileVisibility(isHidden: Bool) {
        userNameLabel.isHidden = isHidden
        userImageView.isHidden = isHidden
        
        if (!isHidden && currentUser != nil) {
            userNameLabel.text = currentUser!.name
            let resource = ImageResource(downloadURL: URL(string: currentUser!.imageURL)!, cacheKey: userImageURLCacheKey)
            userImageView.kf.setImage(with: resource)
        }
    }
}

extension ProfileViewController: LoginButtonDelegate {
    fileprivate func showLoginError(_ error: Error?) {
        print("Login error: \(String(describing: error?.localizedDescription))")
        let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("Canceled")
        case .success( _, _, let accessToken):
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    self.showLoginError(error)
                    return
                }
                let imageURL = (user?.providerData[0].photoURL?.absoluteString)! + "?type=large"
                let userData = try! FirestoreEncoder().encode(User(UID: (user?.uid)!,name: (user?.displayName)!, email: (user?.email)!, imageURL: imageURL, rating: nil, comments: nil, settings: nil, location: nil))
                self.userRepository?.saveUser(userData: userData)
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did logout via LoginButton")
        do {
            try Auth.auth().signOut()
            toogleProfileVisibility(isHidden: true)
        } catch {
            print("Error on logout via LoginButton")
        }
    }
}



