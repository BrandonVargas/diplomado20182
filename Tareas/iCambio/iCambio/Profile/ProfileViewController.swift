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

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
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
        currentUser = userRepository?.getCurrentUser()
        userRepository?.userSubject.subscribe(onNext: { _ in
            self.currentUser = self.userRepository?.getCurrentUser()
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
            userImageView.downloadedFrom(link: currentUser!.imageURL)
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
                let userData = try! FirestoreEncoder().encode( User(UID: (user?.uid)!,name: (user?.displayName)!, email: (user?.email)!, imageURL: (user?.photoURL?.absoluteString)!))
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



