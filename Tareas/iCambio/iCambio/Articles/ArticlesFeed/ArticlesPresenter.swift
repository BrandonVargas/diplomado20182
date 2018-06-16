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
    let disposeBag = DisposeBag()
    
    init(view: ArticlesTableView) {
        self.view = view
        articlesRepository = ArticlesRepository()
    }
    
    func loadAndListenAllArticles() {
        articlesRepository?.getArticlesSubject().subscribe(onNext: { (article) in
            self.view.addArticle(article: article)
        }, onError: { error in
           self.view.showErrorDialogDefault(title: "Error",message: "Ocurrio un error: \(error)")
        })
            .disposed(by: disposeBag)
        articlesRepository?.listenAriticlesUpdates()
    }
}

protocol ArticlesPresenterDelegate {
    func loadAndListenAllArticles()
}
