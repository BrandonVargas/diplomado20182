//
//  BaseView.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 19/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

protocol BaseViewDelegate {
    func displaySpinner(onView : UIView) -> UIView
    func removeSpinner(spinner :UIView?)
    func showErrorDialogDefault(title: String, message: String)
    func showDialogAction(title: String, message: String, action: () -> Void)
}
