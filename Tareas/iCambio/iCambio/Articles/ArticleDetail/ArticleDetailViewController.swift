//
//  ArticleDetailViewController.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 09/06/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher
import FirebaseAuth

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "productDetailImage")
        }
    }
    @IBOutlet weak var pagerControl: FSPageControl! {
        didSet {
            self.pagerControl.numberOfPages = self.article?.pictures.count ?? 0
            self.pagerControl.contentHorizontalAlignment = .center
            self.pagerControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var offersButton: UIButton!
    
    var article: Article? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        if (article?.userUID == Auth.auth().currentUser?.uid){
            offersButton.setTitle("Revisar ofertas", for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .done, target: self, action: #selector(editArticle))
        }
        self.title = article?.name
        descriptionTextView.text = article?.description
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerControl.hidesForSinglePage = true
        if ((article?.pictures.count ?? 0) > 1) {
         pagerView.isInfinite = true
        } else {
            pagerControl.isHidden = true
        }
    }
    
    @IBAction func OffersButtonClicked(_ sender: UIButton) {
    }
    
    @objc func editArticle() {
        
    }
}

extension ArticleDetailViewController: FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return article?.pictures.count ?? 0
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "productDetailImage", at: index)
        cell.imageView?.contentMode = .scaleAspectFit
        let resource = ImageResource(downloadURL: URL(string: (article?.pictures[index])!)!, cacheKey: article?.pictures[index])
        cell.imageView?.kf.setImage(with: resource)
        return cell
    }
}

extension ArticleDetailViewController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pagerControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pagerControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pagerControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}
