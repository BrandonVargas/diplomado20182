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

class MakeOfferViewController: UIViewController {
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    var selectedArticle: Article? = nil
    private var CELL_IDENTIFIER = "OfferArticleViewCell"
    private var makeOfferPresenter: MakeOfferPresenterDelegate? = nil
    private var offersRepo: OffersRepository? = nil
    private var userArticles: Array<Article> = []
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        offersRepo = OffersRepository()
        makeOfferPresenter = MakeOfferPresenter(view: self)
        makeOfferPresenter?.getUserArticles()
    }
    
    private func setupView() {
        articlesTableView.dataSource = self
        articlesTableView.allowsMultipleSelection = true
        self.title = "Ofertar"
    }
    
    @IBAction func iCambioClicked(_ sender: UIButton) {
        makeOfferPresenter?.makeOffer(article: selectedArticle!, articlesOffered: userArticles)
    }
}

extension MakeOfferViewController: MakeOfferViewDelegate {
    func pupulateArticles(_ articles: Array<Article>) {
        userArticles.append(contentsOf: articles)
        self.articlesTableView.reloadData()
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
        
        offersRepo?.getOffersQuantity(userId: article.userUID, articleId: article.id)
            .subscribe(onNext: { offersQty in
                cell.articleOffersLabel.text = "\(offersQty)  oferta" + ((offersQty == 1) ? "":"s")
            }, onError: {error in
                cell.articleOffersLabel.text = ""
            }
        ).disposed(by: self.disposeBag)
        
        return cell
    }
}

protocol MakeOfferViewDelegate {
    func pupulateArticles(_ articles: Array<Article>)
    func showSuccessDialogAndExit()
}
