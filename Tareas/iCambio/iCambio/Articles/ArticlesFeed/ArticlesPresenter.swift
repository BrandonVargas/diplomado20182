//
//  ArticlesPresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 08/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import RxSwift
import Firebase

class ArticlesPresenter {
    var view: ArticlesTableViewController
    var articlesRepository: ArticlesRepository? = nil
    let userRepository = UserRepository()
    let disposeBag = DisposeBag()
    
    init(view: ArticlesTableViewController) {
        self.view = view
        articlesRepository = ArticlesRepository()
    }
    
    func loadAndListenAllArticles() {
        articlesRepository?.getArticlesSubject().subscribe(onNext: { (article, diffType) in
            switch diffType {
            case DocumentChangeType.added:
                self.view.addArticle(article)
                break
            case .modified:
                break
            case .removed:
                self.view.removeArticle(article)
            }
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
