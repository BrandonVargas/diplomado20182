//
//  MakeOfferViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 27/06/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import CodableFirebase
import Firebase

class MakeOfferViewController: UIViewController {
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    var selectedArticle: Article? = nil
    private var CELL_IDENTIFIER = "OfferArticleViewCell"
    private var makeOfferPresenter: MakeOfferPresenter? = nil
    private var userArticles = [Article]()
    private var selectedArticles = [Article]()
    private var disposeBag = DisposeBag()
    private var spinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner = displaySpinner(onView: self.view)
        setupView()
        makeOfferPresenter = MakeOfferPresenter(view: self)
        makeOfferPresenter?.getCurrentUser(userUID: (Auth.auth().currentUser?.uid)!)
    }
    
    func bindUserInformation(_ user: User) {
        self.makeOfferPresenter?.getUserArticles(user)
    }
    
    private func setupView() {
        articlesTableView.dataSource = self
        articlesTableView.allowsMultipleSelection = true
        self.title = "Ofertar"
    }
    
    @IBAction func iCambioClicked(_ sender: UIButton) {
        for index in articlesTableView.indexPathsForSelectedRows! {
            selectedArticles.append(userArticles[index.row])
        }
        makeOfferPresenter?.makeOffer(article: selectedArticle!, articlesOffered: selectedArticles)
    }
    
    func populateArticles(_ articles: Array<Article>) {
        userArticles.append(contentsOf: articles)
        self.articlesTableView.reloadData()
        self.removeSpinner(spinner: self.spinner)
    }
    
    func showSuccessDialogAndExit() {
        showDialogAction(title: "Felicidades", message: "Tu oferta ha sido enviada", action: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
}

extension MakeOfferViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as? ArticleToOfferTableViewCell else {
            fatalError("The dequeued cell is not an instance of ArticleToOfferTableViewCell.")
        }
        
        let article: Article = userArticles[indexPath.row]
        
        cell.articleNameLabel.text = article.name
        
        cell.articleOffersLabel.text = "\(article.offers.count)  oferta" + ((article.offers.count == 1) ? "":"s")
        
        return cell
    }
}
