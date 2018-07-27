//
//  ArticlesPresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 08/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import RxSwift

class ArticlesPresenter: ArticlesPresenterDelegate {
    var view: ArticlesTableView
    var articlesRepository: ArticlesRepositoryDelegate? = nil
    let userRepository = UserRepository()
    let disposeBag = DisposeBag()
    
    init(view: ArticlesTableView) {
        self.view = view
        articlesRepository = ArticlesRepository()
    }
    
    func loadAndListenAllArticles() {
        articlesRepository?.getArticlesSubject().subscribe(onNext: { (article) in
            self.view.addArticle(article: article)
        }, onError: { error in
           self.view.showErrorDialogDefault(error: "Ocurrio un error: \(error)")
        }).disposed(by: disposeBag)
        listenToUserPhotos()
        articlesRepository?.listenAriticlesUpdates()
    }
    
    func listenToUserPhotos() {
        userRepository.usersImagesSubject
            .subscribe(onNext: {(index, stringURL) in
            self.view.loadUserPhoto(index: index, stringURL: stringURL)
        }).disposed(by: disposeBag)
    }
}

protocol ArticlesPresenterDelegate {
    func loadAndListenAllArticles()
    func listenToUserPhotos()
}
