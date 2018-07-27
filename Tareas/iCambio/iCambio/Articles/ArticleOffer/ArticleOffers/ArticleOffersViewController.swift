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
    private var articles = Array<Article>()
    private var disposeBag = DisposeBag()
    private var offers = Array<Offer> ()
    private var offersComplete = Array<(Offer, Array<Article>)> ()
    private var offersRepository: OffersRepositoryDelegate? = nil
    private var userRepository = UserRepository()
    private var spinnerView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersRepository = OffersRepository()
        spinnerView = displaySpinner(onView: view)
        setupView()
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
        updateOfferNumbers()
    }
    
    func updateOfferNumbers() {
        offersRepository?.getOffers(userId: (article?.userUID)!, articleId: (article?.id)!)
            .subscribe(onNext: { querySnapshot in
                print("OFFERS: \(querySnapshot.count)")
                self.offers.removeAll()
                self.offersComplete.removeAll()
                for document in querySnapshot.documents {
                    let offer = try! FirestoreDecoder().decode(Offer.self, from: document.data())
                    self.offers.append(offer)
                }
                self.offersQuantityLabel.text = "\(self.offers.count) " + ((self.offers.count != 1) ? "ofertas":"oferta")
                self.createOffersMap(offers: self.offers)
                //self.offersTableView.reloadData()
            }, onError: { error in
                print("Error getting offers")
            }).disposed(by: disposeBag)
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
        offersRepository?.declineOffer(offer)
            .subscribe(onNext: {
                self.updateOfferNumbers()
            }, onError: {error in
                //Show Error
            }).disposed(by: disposeBag)
    }
    
    func acceptOffer(_ offer: Offer) {
        offersRepository?.acceptOffer(offer)
            .subscribe(onNext: {
                self.goToChat(offer: offer)
            }, onError: {error in
                //Show Error
            }).disposed(by: disposeBag)
    }
    
    private func createOffersMap(offers: Array<Offer>) {
        if (offers.count > 0) {
            for offer in offers {
                offersRepository?.getOfferArticles(articles: offer.itemsOfferingIds)
                .subscribe(onNext: { articles in
                    self.offersComplete.append((offer, articles))
                    self.offersTableView.reloadData()
                    self.removeSpinner(spinner: self.spinnerView)
                }, onError: { error in
                    print("Error al obtener articulos de ofertas -> \(error)")
                }).disposed(by: disposeBag)
            }
        } else {
            self.offersTableView.reloadData()
            self.removeSpinner(spinner: self.spinnerView)
        }
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
        self.userRepository.getUserWithUID(offer.userOfferingUID)
            .subscribe(onNext: { user in
                let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
                cell.userImage.kf.setImage(with: resource)
                cell.usernameLabel.text = user.name
            }).disposed(by: disposeBag)
        let articles = offersComplete[indexPath.row].1
        cell.articlesStackView.onArticleClicked = {[weak self] article in
            guard let strongSelf = self else { return }
            strongSelf.goToArticleDetail(article: article)
        }
        cell.declineClosure = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.declinedOffer(offer)
        }
        cell.iCambioClosure = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.acceptOffer(offer)
        }
        cell.articlesStackView.setArticles(articles)
        return cell
    }
}
