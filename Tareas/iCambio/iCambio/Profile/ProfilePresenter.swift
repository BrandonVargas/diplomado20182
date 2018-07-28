//
//  ProfilePresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 27/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation
import CodableFirebase
import RxSwift

class ProfilePresenter {
    private var view: ProfileViewController
    private var userRepository = UserRepository()
    private var articlesRepository = ArticlesRepository()
    private var disposeBag = DisposeBag()

    init(view: ProfileViewController) {
        self.view = view
    }
    
    func getUser(userUID: String){
        userRepository.getUserWithUID(userUID)
            .subscribe(onNext: { user in
                self.view.bindUserInformation(user)
            }, onError: { error in
                self.view.clearUser()
            }).disposed(by: disposeBag)
    }
    
    func loginUser(_ user: User) {
        userRepository.loginUser(user: user)
            .subscribe(onNext: { user in
                self.view.bindUserInformation(user)
            }, onError: { error in
                self.view.registerUser(user)
            }).disposed(by: disposeBag)
    }
    
    func registerUser(_ user: User) {
        userRepository.registerUser(user)
            .subscribe(onNext: { user in
                self.view.bindUserInformation(user)
            }, onError: { error in
                self.view.clearUser()
            }).disposed(by: disposeBag)
    }
    
    func getUserOffers(_ user: User) {
        userRepository.getUserOffers(user)
            .subscribe(onNext: { offers in
                if (!offers.filter({ offer in offer.status == OfferStates.SUCCESSFUL.rawValue }).isEmpty) {
                    self.view.addUserOffers(offers: offers.filter({ offer in offer.status == OfferStates.SUCCESSFUL.rawValue }))
                }
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
    
    func getUserArticlesAvailable(_ user: User) {
        articlesRepository.getUserAvailableArticles(user)
            .subscribe(onNext: { articles in
                if (!articles.filter({ art in art.available == true }).isEmpty) {
                    self.view.addUserArticlesAvailable(articles: articles.filter({ art in art.available == true }))
                }
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
    
    func logout() {
        userRepository.logout()
            .subscribe(onNext: { success in
                self.view.clearUser()
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
}
