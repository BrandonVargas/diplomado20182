//
//  ArticlesPresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 08/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation
import RxSwift

class AddArticlePresenter {
    var viewController: AddArticleViewController
    let articlesRepository = ArticlesRepository()
    let disposeBag = DisposeBag()
    
    init(viewController: AddArticleViewController) {
        self.viewController = viewController
    }
    
    func publishArticle(article: Article, imagesSelected: Array<String>) {
        var article = article
        viewController.toggle(loading: true)
        let uploadImagesCallBack: (_ :Array<String>, _ :Error?) -> Void = { imagesURLs, error in
            if error != nil {
                self.viewController.toggle(loading: false)
                self.viewController.showErrorDialogDefault(title: "Error",message: "Tu articulo no se pudo publicar, intenta nuevamente")
                return
            }
            article.pictures = imagesURLs
            self.articlesRepository.addArticle(article: article)
                .subscribe(onError: { (error) in
                    self.viewController.toggle(loading: false)
                    self.viewController.showErrorDialogDefault(title: "Error",message: "Tu articulo no se pudo publicar, intenta nuevamente")
                }, onCompleted: {
                    print("Article added")
                    self.viewController.toggle(loading: false)
                    self.viewController.close()
                }).disposed(by: self.disposeBag)
        }
        articlesRepository.uploadImages(imagesSelected, completion: uploadImagesCallBack)
    }
}
