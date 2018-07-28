//
//  ArticlesTableViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 05/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import CodableFirebase

class ArticlesTableViewController: UITableViewController {

    @IBOutlet var articlesTableView: UITableView!
    private var articles: Array<Article> = []
    var articlesPresenter: ArticlesPresenter? = nil
    var userUrls: Array<URL> = [].map { URL(string: $0)! }
    let disposeBag = DisposeBag()
    let cellIdentifier = "ArticleTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        //articlesTableView.prefetchDataSource = self
        articlesTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        articlesPresenter = ArticlesPresenter(view: self)
        loadArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }
        
        let article: Article = articles[indexPath.row]
        
        cell.item = article
        
        UserRepository().getUserImageWith(uid: article.user.documentID)
            .subscribe(onNext: { documents in
                if let document = documents.documents.first {
                    print("Document data: \(document.data())")
                    let user = try! FirestoreDecoder().decode(User.self, from: document.data())
                    let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
                    cell.userImageView.kf.setImage(with: resource)
                }
            }, onError: { error in
                print("Hubo un error \(error)")
            }).disposed(by: self.disposeBag)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        detailViewController.article = articles[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - ArticlesTableView
    func loadArticles() {
        articles.removeAll()
        articlesPresenter?.loadAndListenAllArticles()
    }
    
    func addArticle(_ article: Article) {
        articles.insert(article, at: 0)
        articlesTableView.reloadData()
    }
    
    func removeArticle(_ article: Article) {
        if (articles.contains(where: {art in art.id == article.id})){
            articles = articles.filter{ $0.id != article.id }
        }
        articlesTableView.reloadData()
    }
    
    func loadUserPhoto(index: IndexPath, stringURL: String) {
        let resource = ImageResource(downloadURL: URL(string: stringURL)!, cacheKey: stringURL)
        (articlesTableView.cellForRow(at: index) as! ArticleTableViewCell).userImageView.kf.setImage(with: resource)
        articlesTableView.reloadRows(at: [index], with: UITableViewRowAnimation.none)
    }
    
    func showErrorDialogDefault(error: String) {
        showErrorDialogDefault(title: "Ocurrio un error", message: error)
    }
}
