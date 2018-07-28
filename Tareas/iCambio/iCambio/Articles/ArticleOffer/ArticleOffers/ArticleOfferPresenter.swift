//
//  ArticleOfferViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 28/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import RxSwift
import Firebase

class ArticleOfferPresenter {
    private var view: ArticleOffersViewController
    private var articlesRepository = ArticlesRepository()
    private var offersRepository = OffersRepository()
    private var disposeBag = DisposeBag()
    
    init(view: ArticleOffersViewController) {
        self.view = view
    }
    
    func getOffers(article: Article) {
        if ( article.offers.count > 0 ) {
        articlesRepository.getArticleOffers(article)
            .subscribe(onNext: { offers in
                self.view.updateOfferNumbers(offers: offers)
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        } else {
            self.view.updateOfferNumbers(offers: [])
        }
    }
    
    func getArticlesForOffer(_ offer: Offer) {
        offersRepository.getArticlesForOffer(offer)
            .subscribe(onNext: { articles in
                self.view.addOffer(offer: offer, articles: articles)
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func acceptOffer(_ offer: Offer) {
        offersRepository.acceptOffer(offer)
            .subscribe(onNext: { articles in
                self.view.showDialogSucces(offer: offer)
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
    
    func declineOffer(_ offer: Offer) {
        offersRepository.declineOffer(offer)
            .subscribe(onNext: { articles in
                self.view.deleteOffer(offer)
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
}
