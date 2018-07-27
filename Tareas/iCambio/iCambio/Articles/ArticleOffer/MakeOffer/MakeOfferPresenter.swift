//
//  MakeOfferPresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 27/06/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class MakeOfferPresenter: BaseRepository, MakeOfferPresenterDelegate {
    private var articlesRepository = ArticlesRepository()
    private var disposeBag = DisposeBag()
    private var articlesSubject = PublishSubject<Array<Article>>()
    private var articlesObserver: Observable<Array<Article>>
    private var view: MakeOfferViewDelegate
    
    init(view: MakeOfferViewDelegate) {
        self.view = view
        articlesObserver = articlesSubject
        super.init()
        listenToArticles()
    }
    
    func getUserArticles() {
        articlesRepository.getUserArticles(subject: articlesSubject)
    }
    
    func listenToArticles() {
        let dispoable = articlesObserver.subscribe(onNext: { articles in
            self.view.pupulateArticles(articles)
        })
        dispoable.disposed(by: disposeBag)
    }
    
    func makeOffer(article: Article, articlesOffered: Array<Article>) {
        var articlesOfferedIds: Array<String> = []
        for art in articlesOffered {
            articlesOfferedIds.append(art.id)
        }
        let offer = Offer(id: "", status: OfferStates.PENDING.rawValue, userOfferingUID: (articlesOffered.first?.userUID)! , userOwnerUID: article.userUID, itemOwnerId: article.id, itemsOfferingIds: articlesOfferedIds)
        articlesRepository.makeOffer(offer: offer).subscribe(
            onNext: { document in
                self.updateOfferId(id: document.documentID, path: document.path)
            },onError: { error in
                print("ERROR AL HACER OFERTA")
            }, onCompleted: {
                print("OFERTA EXITOSA")
                self.articlesRepository.changeArticleAvailability(documentsIds: articlesOfferedIds, available: false)
                self.view.showSuccessDialogAndExit()
            }).disposed(by: disposeBag)
    }
    
    func updateOfferId(id: String, path: String) {
        db.document(path).updateData(["id": id])
    }
}

protocol MakeOfferPresenterDelegate {
    func getUserArticles()
    func makeOffer(article: Article, articlesOffered: Array<Article>)
}
