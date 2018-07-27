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
    @IBOutlet weak var raitngStack: RatingControl!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    let cellIdentifierArticles = "ArticleTableViewCell"
    let cellIdentifierOffers = "DealTableViewCell"
    
    let disposeBag = DisposeBag()
    private var userRepository = UserRepository()
    private var currentUser: User?
    private var articlesRepository = ArticlesRepository()
    private var offersRepository = OffersRepository()
    private var articles = [Article]()
    private var deals = [Offer]()
    private var items = [ProfileViewModelItem]()
    private var spinner: UIView? = nil
    var noUserView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        prepareUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        noUserView.backgroundColor = UIColor.black
        noUserView.tag = 101
        noUserView.frame = view.frame
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.center = self.view.center
        loginButton.delegate = self as LoginButtonDelegate
        noUserView.addSubview(loginButton)
        profileTableView.register(UINib(nibName: cellIdentifierArticles, bundle: nil), forCellReuseIdentifier: cellIdentifierArticles)
        profileTableView.register(UINib(nibName: cellIdentifierOffers, bundle: nil), forCellReuseIdentifier: cellIdentifierOffers)
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    func prepareUser() {
        items.removeAll()
        userRepository.fetchCurrentUser().subscribe(onNext: { user in
            self.currentUser = user
            if (self.currentUser != nil) {
                self.toogleProfileVisibility(isHidden: false)
                self.spinner = self.displaySpinner(onView: self.view)
                self.getUserSuccessfulOffers()
            } else {
                self.toogleProfileVisibility(isHidden: true)
            }
        }, onError: { error in
            if (!(error is RxError)) {
                self.showErrorDialogDefault(title: "Ups!", message: error.localizedDescription)
            } else {
                self.toogleProfileVisibility(isHidden: true)
            }
        }).disposed(by: disposeBag)
    }
    
    func toogleProfileVisibility(isHidden: Bool) {
        userNameLabel.isHidden = isHidden
        userImageView.isHidden = isHidden
        profileTableView.isHidden = isHidden
        raitngStack.isHidden = isHidden
        ratingLabel.isHidden = isHidden
        
        if (!isHidden && currentUser != nil) {
            if let viewWithTag = self.view.viewWithTag(101) {
                viewWithTag.removeFromSuperview()
            }
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.profileTableView.frame.width, height: 44.0))
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
            loginButton.center = footerView.center
            loginButton.delegate = self as LoginButtonDelegate
            footerView.addSubview(loginButton)
            self.profileTableView.tableFooterView = footerView
            userNameLabel.text = currentUser!.name
            let resource = ImageResource(downloadURL: URL(string: currentUser!.imageURL)!, cacheKey: currentUser!.imageURL)
            userImageView.kf.setImage(with: resource)
        } else {
            self.view.addSubview(noUserView)
        }
    }
    
    func getUserSuccessfulOffers() {
        offersRepository.getDealsForCurrentUser()
            .subscribe(onNext: { deals in
                if (!deals.isEmpty) {
                    let dealsItem = ProfileViewModelDealItem(deals: deals)
                    self.items.append(dealsItem)
                    print("Deals \(String(describing: deals))")
                    print("Items \(String(describing: self.items))")
                    self.deals = deals
                }
                self.getUserArticles()
            }, onError: { error in
                print("Error obteniendo ofertas")
                self.getUserArticles()
            }).disposed(by: disposeBag)
    }
    
    func getUserArticles() {
        articlesRepository.getUserAvailableArticles()
            .subscribe(onNext: { articles in
                if (!articles.isEmpty){
                    let articlesItem = ArticleViewModelItem(articles: articles)
                    self.items.append(articlesItem)
                    print("Articles \(String(describing: articles))")
                    print("Items \(String(describing: self.items))")
                    self.articles = articles
                }
                self.profileTableView.reloadData()
                self.removeSpinner(spinner: self.spinner)
            }, onError: { error in
                print("Error obteniendo articulos")
                self.removeSpinner(spinner: self.spinner)
                self.profileTableView.reloadData()
            }).disposed(by: disposeBag)
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
                self.userRepository.saveUser(userData: userData)
                self.prepareUser()
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did logout via LoginButton")
        do {
            try Auth.auth().signOut()
            prepareUser()
        } catch {
            print("Error on logout via LoginButton")
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .article:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierArticles, for: indexPath) as? ArticleTableViewCell else {
                fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
            }
            cell.item = articles[indexPath.row]
            return cell
        case .deal:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierOffers, for: indexPath) as? DealTableViewCell else {
                fatalError("The dequeued cell is not an instance of DealTableViewCell.")
            }
            cell.item = deals[indexPath.row]
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        switch item.type {
        case .article:
            let detailViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
            detailViewController.article = articles[indexPath.row]
            navigationController?.pushViewController(detailViewController, animated: true)
        case .deal:
            let chatViewController = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatViewController.offer = deals[indexPath.row]
            navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
}



