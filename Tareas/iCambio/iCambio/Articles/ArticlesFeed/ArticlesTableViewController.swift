//
//  ArticlesTableViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 05/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import RxSwift

class ArticlesTableViewController: UITableViewController {
    
    private var articles: Array<Article> = []
    var articlesPresenter: ArticlesPresenter? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        articlesPresenter = ArticlesPresenter(viewController: self)
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
        
        cell.articleNameLabel.text = article.name
        cell.valueLabel.text = "$\(article.minPrice) - $\(article.maxPrice)"
        
        if(article.pictures.count > 0) {
            cell.articleImageView.downloadedFrom(link: article.pictures[0])
        }
        
        return cell
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
