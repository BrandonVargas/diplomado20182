//
//  ArticlesStackView.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 23/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import Kingfisher

class ArticlesStackView: UIStackView {

    //MARK: Properties
    var onArticleClicked: ((Article) -> Void)?
    var articles = Array<Article>()
    private var articlesImages = [UIImageView]()
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setArticles(_ articles: Array<Article>) {
        self.articles = articles
        setupImages()
    }
    
    //MARK: Private Methods
    private func setupImages() {
        
        // Clear any existing buttons
        for image in articlesImages {
            removeArrangedSubview(image)
            image.removeFromSuperview()
        }
        articlesImages.removeAll()
        
        for article in articles {
            // Create the button
            let imageView = UIImageView()
            
            let resource = ImageResource(downloadURL: URL(string: article.pictures[0])!, cacheKey: article.id)
            imageView.kf.setImage(with: resource)
            
            // Add constraints
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
        
            // create tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
            // add it to the image view;
            imageView.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
            imageView.isUserInteractionEnabled = true
            // Add the button to the stack
            addArrangedSubview(imageView)
            
            // Add the new button to the rating button array
            articlesImages.append(imageView)
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let imageView = gesture.view as? UIImageView {
            guard let index = articlesImages.index(of: imageView) else {
                fatalError("The button, \(imageView), is not in the ratingButtons array: \(articlesImages)")
            }
            onArticleClicked?(articles[index])
        }
    }
}
