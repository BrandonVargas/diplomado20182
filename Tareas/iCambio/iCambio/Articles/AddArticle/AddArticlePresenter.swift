//
//  ArticlesPresenter.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 08/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import RxSwift
import CodableFirebase

class AddArticlePresenter {
    var viewController: AddArticleViewController
    let articlesRepository = ArticlesRepository()
    let userRepository = UserRepository()
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
                .subscribe(onNext: { (documentReference) in
                    self.articlesRepository.addArticleID(id: documentReference.documentID, path: documentReference.path)
                    article.user.getDocument(completion: { doc, error in
                        let user = try! FirestoreDecoder().decode(User.self, from: (doc?.data())!)
                        var data = user.articles
                        data.append(documentReference)
                        article.user.updateData(["articles": data])
                    })
                }, onError: { (error) in
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
