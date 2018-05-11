//
//  ArticlesPresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 08/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import RxSwift

class ArticlesPresenter {
    var viewController: ArticlesTableViewController
    let articlesRepository = ArticlesRepository()
    let disposeBag = DisposeBag()
    
    init(viewController: ArticlesTableViewController) {
        self.viewController = viewController
    }
    
    func loadAndListenAllArticles() {
        articlesRepository.articlesSubject.subscribe(onNext: { (article) in
            self.viewController.addArticle(article: article)
        }, onError: { error in
            self.viewController.showErrorDialogDefault(title: "Error",message: "Ocurrio un error: \(error)")
        })
            .disposed(by: disposeBag)
        articlesRepository.listenAriticlesUpdates()
    }
}
