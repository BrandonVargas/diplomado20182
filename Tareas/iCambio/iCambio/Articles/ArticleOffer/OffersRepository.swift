//
//  OffersRepository.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 22/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import RxSwift
import Firebase
import CodableFirebase

class OffersRepository: BaseRepository, OffersRepositoryDelegate {
    
    private let userRepository = UserRepository()
    private let articlesRepository = ArticlesRepository()
    private let disposeBag = DisposeBag()
    
    func getOffers(userId: String, articleId: String) -> Observable<QuerySnapshot> {
        return db.collection("offers")
            .whereField("userOwnerUID", isEqualTo: userId)
            .whereField("itemOwnerId", isEqualTo: articleId)
            .whereField("status", isEqualTo: OfferStates.PENDING.rawValue)
            .rx
            .getDocuments()
    }
    
    func getOffersQuantity(userId: String, articleId: String) -> Observable<Int> {
        return Observable.create { observer in
            self.db.collection("offers")
                .whereField("userOwnerUID", isEqualTo: userId)
                .whereField("itemOwnerId", isEqualTo: articleId)
                .whereField("status", isEqualTo: OfferStates.PENDING.rawValue)
                .rx
                .getDocuments()
                .subscribe(
                    onNext: { query in
                        observer.onNext(query.count)
                    }, onError: { error in
                        observer.onError(error)
                    })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func hasUserOfferedFor(userId: String, articleId: String) -> Observable<Bool> {
        return Observable.create { observer in
            self.db.collection("offers")
                .whereField("userOfferingUID", isEqualTo: userId)
                .whereField("itemOwnerId", isEqualTo: articleId)
                .whereField("status", isEqualTo: OfferStates.PENDING.rawValue)
                .rx
                .getDocuments()
                .subscribe(
                    onNext: { query in
                        if (query.count > 0) {
                            observer.onNext(true)
                        } else {
                            observer.onNext(false)
                        }
                }, onError: { error in
                    observer.onNext(false)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getOfferArticles(articles: Array<String>) -> Observable<Array<Article>> {
        if (!articles.isEmpty) {
            let articleObservables = articles.map{ articleObservable(id: $0) }
            return Observable.zip(articleObservables)
        }
        return Observable.error(RxError.noElements)
    }
    
    func declineOffer(_ offer: Offer) -> Observable<Void> {
        var articles = offer.itemsOfferingIds
        articles.append(offer.itemOwnerId)
        articlesRepository.changeArticleAvailability(articles: articles, available: true)
        return updateOfferStatus(id: offer.id, status: OfferStates.DECLINED.rawValue)
    }
    
    func acceptOffer(_ offer: Offer) -> Observable<Void> {
        var articles = offer.itemsOfferingIds
        articles.append(offer.itemOwnerId)
        articlesRepository.changeArticleAvailability(articles: articles, available: false)
        return updateOfferStatus(id: offer.id, status: OfferStates.SUCCESSFUL.rawValue)
    }
    
    private func articleObservable(id: String) -> Observable<Article> {
        return Observable.create { observer in
            self.db.collection("articles")
                .whereField("id", isEqualTo: id)
                .rx
                .getDocuments()
                .subscribe(onNext: { snapshot in
                    print("id: \(id) snapshot count: \(snapshot.count)")
                    let article = try! FirestoreDecoder().decode(Article.self, from: snapshot.documents[0].data())
                    observer.onNext(article)
                }, onError: { error in
                    observer.onError(error)
                    print("Error obteniendo articulo")
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func updateOfferStatus(id: String, status: Int) -> Observable<Void> {
        return self.db.collection("offers")
            .document(id)
            .rx
            .updateData(["status": status])
    }
    
    func getDealsForCurrentUser() -> Observable<[Offer]> {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        return Observable.create({ observer in
            Observable.zip([self.getSuccessfulOffersOwner(userUID: currentUserId),
                            self.getSuccessfulOffersOffering(userUID: currentUserId)])
                .subscribe(onNext: { offers in
                    print("--------------------\n\n getDealsForCurrentUser \(String(describing: offers)) \n\n--------------------")
                    observer.onNext(offers.compactMap{$0})
                }, onError: { error in
                    print("--------------------\n\n getDealsForCurrentUser \(error) \n\n--------------------")
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    private func getSuccessfulOffersOwner(userUID: String) -> Observable<Offer?> {
        return Observable.create { observer in
            self.db.collection("offers")
                .whereField("userOwnerUID", isEqualTo: userUID)
                .whereField("status", isEqualTo: OfferStates.SUCCESSFUL.rawValue)
                .rx
                .getDocuments()
                .subscribe(
                    onNext: { query in
                        print("--------------------\n\n getSuccessfulOffersOwner \(query.documents.count) \n\n--------------------")
                        if (query.documents.isEmpty) {
                            observer.onNext(nil)
                        } else {
                            for doc in query.documents {
                                let offer = try! FirestoreDecoder().decode(Offer.self, from:doc.data())
                                observer.onNext(offer)
                            }
                        }
                }, onError: { error in
                    print("--------------------\n\n getSuccessfulOffersOwner \(error) \n\n--------------------")
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func getSuccessfulOffersOffering(userUID: String) -> Observable<Offer?> {
        return Observable.create { observer in
            self.db.collection("offers")
                .whereField("userOfferingUID", isEqualTo: userUID)
                .whereField("status", isEqualTo: OfferStates.SUCCESSFUL.rawValue)
                .rx
                .getDocuments()
                .subscribe(
                    onNext: { query in
                        print("--------------------\n\n getSuccessfulOffersOffering \(query.documents.count) \n\n--------------------")
                        if (query.documents.isEmpty) {
                            observer.onNext(nil)
                        } else {
                            for doc in query.documents {
                                let offer = try! FirestoreDecoder().decode(Offer.self, from:doc.data())
                                observer.onNext(offer)
                            }
                        }
                }, onError: { error in
                    print("--------------------\n\n getSuccessfulOffersOffering \(error) \n\n--------------------")
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getArticlesForOffer(_ offer: Offer) -> Observable<[Article]>{
        return Observable.zip(offer.itemsOfferingIds.compactMap( { doc in
            self.db.collection("articles")
                .document(doc.documentID)
                .rx
                .getDocument()
                .flatMap({ art -> Observable<Article> in
                    let article = try! FirestoreDecoder().decode(Article.self, from: (art?.data())!)
                    return Observable.just(article)
                })
            })
        )
    }
}

protocol OffersRepositoryDelegate {
    func getOffers(userId: String, articleId: String) -> Observable<QuerySnapshot>
    func getOfferArticles(articles: Array<String>) -> Observable<Array<Article>>
    func declineOffer(_ offer: Offer) -> Observable<Void>
    func acceptOffer(_ offer: Offer) -> Observable<Void>
    func getDealsForCurrentUser() -> Observable<[Offer]>
}
