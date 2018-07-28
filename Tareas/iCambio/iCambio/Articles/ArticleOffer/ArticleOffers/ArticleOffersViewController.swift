//
//  ArticleOffersViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 22/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import CodableFirebase

class ArticleOffersViewController: UIViewController {
    
    private let CELL_IDENTIFIER = "OfferTableViewCell"

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var offersQuantityLabel: UILabel!
    @IBOutlet weak var offersTableView: UITableView!
    
    var article: Article? = nil
    let cellSpacingHeight: CGFloat = 8
    private var articleOffersPresenter: ArticleOfferPresenter? = nil
    private var offers = Array<Offer> ()
    private var offersComplete = [(Offer, [Article])] ()
    private var spinnerView: UIView?
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleOffersPresenter = ArticleOfferPresenter(view: self)
        spinnerView = displaySpinner(onView: view)
        setupView()
        articleOffersPresenter?.getOffers(article: article!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        offersTableView.delegate = self
        offersTableView.dataSource = self
        let resource = ImageResource(downloadURL: URL(string: (self.article?.pictures[0])!)!, cacheKey: self.article?.id)
        articleImageView.kf.setImage(with: resource)
        articleNameLabel.text = article?.name
    }
    
    func addOffer(offer: Offer, articles: [Article]) {
        offersComplete.append((offer, articles))
        self.offersTableView.reloadData()
        self.removeSpinner(spinner: self.spinnerView)
    }
    
    func updateOfferNumbers(offers: [Offer]) {
        if (offers.count == 0) {
            self.removeSpinner(spinner: self.spinnerView)
        }
        offersQuantityLabel.text = "\(offers.count) " + ((offers.count != 1) ? "ofertas":"oferta")
        for offer in offers {
            articleOffersPresenter?.getArticlesForOffer(offer)
        }
    }
    
    func goToArticleDetail(article: Article) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        detailViewController.article = article
        detailViewController.canMakeOffers = false
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func goToChat(offer: Offer){
        let chatViewController = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatViewController.offer = offer
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func declinedOffer(_ offer: Offer) {
        articleOffersPresenter?.declineOffer(offer)
    }
    
    func acceptOffer(_ offer: Offer) {
        articleOffersPresenter?.acceptOffer(offer)
    }
    
    func deleteOffer(_ offer: Offer) {
        articleOffersPresenter?.getOffers(article: article!)
    }
    
    func showDialogSucces(offer: Offer) {
        showDialogAction(title: "Oferta aceptada", message: "Serás dirigido al chat de esta oferta", action: { self.goToChat(offer: offer)})
    }
}

extension ArticleOffersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
}

extension ArticleOffersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return offersComplete.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as? OfferTableViewCell else {
            fatalError("The dequeued cell is not an instance of OfferTableViewCell.")
        }
        
        //View design stuff
        // add border and color
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        let offer: Offer = offersComplete[indexPath.row].0
        offer.userOffering.getDocument(completion: { doc, error in
            let user = try! FirestoreDecoder().decode(User.self, from: (doc?.data())!)
            let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
            cell.userImage.kf.setImage(with: resource)
            cell.usernameLabel.text = user.name
        })
        
        let articles = offersComplete[indexPath.row].1
        cell.articlesStackView.onArticleClicked = {[weak self] article in
            guard let strongSelf = self else { return }
            strongSelf.goToArticleDetail(article: article)
        }
        cell.declineClosure = {[weak self] in
            guard let strongSelf = self else { return }
            print("DECLINE")
            strongSelf.declinedOffer(offer)
        }
        cell.iCambioClosure = {[weak self] in
            guard let strongSelf = self else { return }
            print("iCambio")
            strongSelf.acceptOffer(offer)
        }
        cell.articlesStackView.setArticles(articles)
        return cell
    }
}
