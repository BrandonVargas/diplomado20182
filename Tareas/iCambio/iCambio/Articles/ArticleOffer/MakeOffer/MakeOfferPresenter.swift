//
//  MakeOfferPresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 27/06/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class MakeOfferPresenter: BaseRepository {
    private var articlesRepository = ArticlesRepository()
    private var userRepository = UserRepository()
    private var disposeBag = DisposeBag()
    private var articlesSubject = PublishSubject<Array<Article>>()
    private var articlesObserver: Observable<Array<Article>>
    private var view: MakeOfferViewController
    
    init(view: MakeOfferViewController) {
        self.view = view
        articlesObserver = articlesSubject
        super.init()
    }
    
    func getUserArticles(_ user: User) {
        articlesRepository.getUserAvailableArticles(user)
            .subscribe(onNext: { articles in
                if (!articles.isEmpty) {
                    self.view.populateArticles(articles.filter( { art in art.available == true } ))
                }
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
    
    func makeOffer(article: Article, articlesOffered: Array<Article>) {
        var articlesOffer = [DocumentReference]()
        Observable.combineLatest(articlesRepository.getArticleReference(article),
             articlesRepository.getArticlesReferences(articlesOffered),
             userRepository.fetchCurrentUserReference(),
             resultSelector: { (artRef, artsRefs, userRef) in
                return (artRef, artsRefs, userRef)
        }).subscribe(onNext: { (artRef, artsRefs, userRef) in
            let offer = Offer(id: "", status: OfferStates.PENDING.rawValue, userOffering: userRef, userOwnerUID: article.user , itemOwnerId: artRef , itemsOfferingIds: artsRefs)
            articlesOffer.append(contentsOf: artsRefs)
            self.articlesRepository.makeOffer(offer: offer).subscribe(
                onNext: { document in
                    offer.userOffering.getDocument(completion: { doc, error in
                        let user = try! FirestoreDecoder().decode(User.self, from: (doc?.data())!)
                        var data = user.offers
                        data.append(document)
                        offer.userOffering.updateData(["offers": data])
                    })
                    offer.userOwnerUID.getDocument(completion: { doc, error in
                        let user = try! FirestoreDecoder().decode(User.self, from: (doc?.data())!)
                        var data = user.offers
                        data.append(document)
                        offer.userOwnerUID.updateData(["offers": data])
                    })
                    offer.itemOwnerId.getDocument(completion: { doc, error in
                        let article = try! FirestoreDecoder().decode(Article.self, from: (doc?.data())!)
                        var data = article.offers
                        data.append(document)
                        offer.itemOwnerId.updateData(["offers": data])
                    })
                    for ref in offer.itemsOfferingIds {
                        ref.getDocument(completion: { doc, error in
                            let article = try! FirestoreDecoder().decode(Article.self, from: (doc?.data())!)
                            var data = article.offers
                            data.append(document)
                            ref.updateData(["offers": data])
                        })
                    }
                    self.updateOfferId(id: document.documentID, path: document.path)
                },onError: { error in
                    print("ERROR AL HACER OFERTA")
                }, onCompleted: {
                    print("OFERTA EXITOSA")
                    self.articlesRepository.changeArticleAvailability(articles: articlesOffer, available: false)
                    self.view.showSuccessDialogAndExit()
                }).disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)
    }
    
    func updateOfferId(id: String, path: String) {
        db.document(path).updateData(["id": id])
    }
    
    func getCurrentUser(userUID: String){
        userRepository.getUserWithUID(userUID)
            .subscribe(onNext: { user in
                self.view.bindUserInformation(user)
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
}
