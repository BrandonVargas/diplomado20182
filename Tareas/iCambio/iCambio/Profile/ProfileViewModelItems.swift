//
//  ProfileViewModelItems.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 26/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation

enum ProfileViewModelItemType {
    case deal
    case article
}

class ProfileViewModelDealItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .deal
    }
    var sectionTitle: String {
        return "Tratos"
    }
    
    var rowCount: Int {
        return deals.count
    }
    var deals: [Offer]
    init(deals: [Offer]) {
        self.deals = deals
    }
}

class ArticleViewModelItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .article
    }
    var sectionTitle: String {
        return "Mis articulos disponibles"
    }
    
    var rowCount: Int {
        return articles.count
    }
    var articles: [Article]
    init(articles: [Article]) {
        self.articles = articles
    }
}
