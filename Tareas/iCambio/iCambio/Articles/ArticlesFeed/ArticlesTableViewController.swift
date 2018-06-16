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

class ArticlesTableViewController: UITableViewController, ArticlesTableView{
    
    private var articles: Array<Article> = []
    var articlesPresenter: ArticlesPresenterDelegate? = nil
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cellIdentifier = "ArticleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }
        
        let article: Article = articles[indexPath.row]
        
        UserRepository().getUserImageWith(uid: article.userUID).subscribe(
            onNext : { imageURL in
                let resource = ImageResource(downloadURL: URL(string: imageURL)!, cacheKey: article.userUID)
                cell.userImageView.kf.setImage(with: resource)
        }).disposed(by: disposeBag)
        
        cell.articleNameLabel.text = article.name
        
        if(article.pictures.count > 0) {
            let resource = ImageResource(downloadURL: URL(string: article.pictures[0])!, cacheKey: article.pictures[0])
            cell.articleImageView.kf.setImage(with: resource)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        detailViewController.article = articles[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func loadArticles() {
        articles.removeAll()
        articlesPresenter?.loadAndListenAllArticles()
    }
    
    func addArticle(article: Article) {
        articles.insert(article, at: 0)
        self.tableView.reloadData()
    }
    

}

protocol ArticlesTableView: BaseViewDelegate {
    func addArticle(article: Article)
}
