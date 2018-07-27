//
//  File.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 26/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}

extension ProfileViewModelItem {
    var rowCount: Int {
        return 1
    }
}
